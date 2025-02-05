import 'package:pet_project/src/core/api_endpoints.dart';
import 'package:story_view/story_view.dart';

class StoryModel {
  final int id;
  final int userId;
  final String mediaType;
  final String mediaUrl;
  final String textContent;
  final String privacy;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final StoryUserModel user; // New field for the user data

  StoryModel({
    required this.id,
    required this.userId,
    required this.mediaType,
    required this.mediaUrl,
    required this.textContent,
    required this.privacy,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    required this.user, // Initialize the user object
  });

  // From JSON
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    String mediaType =
        json['media_type']?.isEmpty ?? true ? 'image' : json['media_type'];

    return StoryModel(
      id: json['id'],
      userId: json['user_id'],
      mediaType: mediaType,
      mediaUrl: json['media_url'] ?? '',
      textContent:
          json['text_content'] ?? '', // Fallback to empty string if null
      privacy: json['privacy'] ??
          'public', // Fallback to 'public' if privacy is null
      expiresAt: DateTime.parse(json['expires_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: StoryUserModel.fromJson(json['user']), // Parse the 'user' object
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'text_content': textContent,
      'privacy': privacy,
      'expires_at': expiresAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(), // Convert the 'user' object to JSON
    };
  }
}

class StoryUserModel {
  final int id;
  final String username;
  final String name;
  final String profileImage;

  StoryUserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.profileImage,
  });

  // From JSON
  factory StoryUserModel.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] == null
        ? ""
        : ApiEndpoints.baseImageUrl + json['profile_image'];
    return StoryUserModel(
      id: json['id'],
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      profileImage: profileImage, // Fallback to empty string if null
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profile_image': profileImage,
    };
  }
}

class AllUserStoryModel {
  final StoryUserModel user;
  final List<StoryItem> stories;

  AllUserStoryModel({required this.user, required this.stories});
}
