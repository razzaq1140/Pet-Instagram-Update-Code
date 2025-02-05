class MyPostModel {
  int id;
  int userId;
  List<String> mediaPaths;
  String caption;
  DateTime createdAt;
  DateTime updatedAt;
  bool likedByUser;
  bool savedByUser;
  int commentsCount;
  int likesCount;
  int savesCount;
  List<MyPostLikeModel> likes;
  List<MyPostCommentModel> comments;
  List<MyPostSaveModel> saves;

  MyPostModel({
    required this.id,
    required this.userId,
    required this.mediaPaths,
    required this.caption,
    required this.createdAt,
    required this.updatedAt,
    required this.likedByUser,
    required this.savedByUser,
    required this.commentsCount,
    required this.likesCount,
    required this.savesCount,
    required this.likes,
    required this.comments,
    required this.saves,
  });

  factory MyPostModel.fromJson(Map<String, dynamic> json) {
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
    return MyPostModel(
      id: json['id'],
      userId: json['user_id'],
      mediaPaths: mediaPathsList,
      caption: json['caption'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      likedByUser: json['liked_by_user'],
      savedByUser: json['saved_by_user'],
      commentsCount: json['comments_count'],
      likesCount: json['likes_count'],
      savesCount: json['saves_count'],
      likes: (json['likes'] as List)
          .map((likeJson) => MyPostLikeModel.fromJson(likeJson))
          .toList(),
      comments: (json['comments'] as List)
          .map((commentJson) => MyPostCommentModel.fromJson(commentJson))
          .toList(),
      saves: (json['saves'] as List)
          .map((saveJson) => MyPostSaveModel.fromJson(saveJson))
          .toList(),
    );
  }
}

class MyPostLikeModel {
  int id;
  int userId;
  int postId;
  DateTime createdAt;
  DateTime updatedAt;

  MyPostLikeModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyPostLikeModel.fromJson(Map<String, dynamic> json) {
    return MyPostLikeModel(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class MyPostCommentModel {
  int id;
  String content;
  DateTime createdAt;
  MyPostUserModel user;
  bool likedByUser;

  MyPostCommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.user,
    required this.likedByUser,
  });

  factory MyPostCommentModel.fromJson(Map<String, dynamic> json) {
    return MyPostCommentModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      user: MyPostUserModel.fromJson(json['user']),
      likedByUser: json['liked_by_user'],
    );
  }
}

class MyPostSaveModel {
  int id;
  int userId;
  int postId;
  DateTime createdAt;
  DateTime updatedAt;

  MyPostSaveModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyPostSaveModel.fromJson(Map<String, dynamic> json) {
    return MyPostSaveModel(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class MyPostUserModel {
  int id;
  String name;
  String username;
  String profileImage;

  MyPostUserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
  });

  factory MyPostUserModel.fromJson(Map<String, dynamic> json) {
    return MyPostUserModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}
