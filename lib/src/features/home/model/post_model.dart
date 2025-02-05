import '../../../core/api_endpoints.dart';
import '../../../models/comment_model.dart';

class PostModel {
  final int id;
  final int userId;
  final List<String> mediaPaths;
  final String caption;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool likedByUser;
  final bool savedByUser;
  int commentsCount;
  int likedCount;
  final int savedCount;
  final PostUserModel user;
  final List<PostLikeModel> likes;
  final List<PostSaveModel> saves;
  final List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.userId,
    required this.mediaPaths,
    required this.caption,
    required this.createdAt,
    required this.updatedAt,
    required this.likedByUser,
    required this.savedByUser,
    required this.commentsCount,
    required this.likedCount,
    required this.savedCount,
    required this.user,
    required this.likes,
    required this.saves,
    required this.comments,
  });

  // From JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> mediaPathsList = List<String>.from(json['media_paths'] ?? []);
    if (mediaPathsList.isNotEmpty) {
      mediaPathsList = mediaPathsList.map((path) {
        if (path.contains('public')) {
          return path; // URL is already complete in JSON
        } else {
          final updatedPath = path.replaceAll('uploads', 'public/uploads');
          return updatedPath;
        }
      }).toList();
    }

    return PostModel(
      id: json['id'],
      userId: json['user_id'],
      mediaPaths: mediaPathsList,
      caption: json['caption'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      likedByUser: json['liked_by_user'] ?? false, // Null check for bool
      savedByUser: json['saved_by_user'] ?? false, // Null check for bool
      commentsCount: json['comments_count'] ?? 0,
      likedCount: json['liked_count'] ?? 0,
      savedCount: json['saved_count'] ?? 0,
      user: PostUserModel.fromJson(json['user']),
      likes: (json['likes'] as List)
          .map((e) => PostLikeModel.fromJson(e))
          .toList(),
      saves: (json['saves'] as List)
          .map((e) => PostSaveModel.fromJson(e))
          .toList(),
      comments: (json['comments'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList(),
    );
  }
}

class PostSaveModel {
  final int id;
  final int userId;
  final int postId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostSaveModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory PostSaveModel.fromJson(Map<String, dynamic> json) {
    return PostSaveModel(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class PostUserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? contactNumber;
  final String username;
  final String about;
  final String dogType;
  final String breed;
  final int age;
  final bool isActive;
  final double weight;
  final String profileImage;
  final bool isPrivate; // Make sure this is a bool, not nullable

  PostUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.contactNumber,
    required this.username,
    required this.about,
    required this.dogType,
    required this.breed,
    required this.age,
    required this.isActive,
    required this.weight,
    required this.profileImage,
    required this.isPrivate, // Ensure it is a bool
  });

  // From JSON
  factory PostUserModel.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] != null
        ? json['profile_image'].toString().contains('http')
            ? json['profile_image']
            : ApiEndpoints.baseImageUrl + json['profile_image']
        : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';

    return PostUserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      contactNumber: json['contact_number'],
      username: json['username'] ?? '',
      about: json['about'] ?? '',
      dogType: json['dog_type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      isActive: json['is_active'] == 1, // Assuming 1 is true, 0 is false
      weight: json['weight']?.toDouble() ?? 0.0,
      profileImage: profileImage,
      isPrivate: json['is_private'] == null
          ? false
          : json['is_private'] == 1, // Ensure null check
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'contact_number': contactNumber,
      'username': username,
      'about': about,
      'dog_type': dogType,
      'breed': breed,
      'age': age,
      'is_active': isActive ? 1 : 0,
      'weight': weight,
      'profile_image': profileImage,
      'is_private': isPrivate ? 1 : 0, // Store as 1 or 0
    };
  }
}

// Like Model
class PostLikeModel {
  final int id;
  final int userId;
  final int postId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostLikeModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory PostLikeModel.fromJson(Map<String, dynamic> json) {
    return PostLikeModel(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
