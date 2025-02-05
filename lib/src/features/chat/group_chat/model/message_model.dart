import 'package:pet_project/src/core/api_endpoints.dart';

class GroupChatMessageModel {
  int id;
  int chatGroupId;
  int userId;
  String? message;
  String? imageUrl;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;
  GroupChatUserModel user;

  GroupChatMessageModel({
    required this.id,
    required this.chatGroupId,
    required this.userId,
    this.message,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  // Factory method to create a Message object from JSON
  factory GroupChatMessageModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['image_url'];
    if (imageUrl != null) {
      if (imageUrl.contains('public')) {
      } else {
        final updatedUrl = imageUrl.replaceAll('uploads', 'public/uploads');
        imageUrl = updatedUrl;
      }
    }

    return GroupChatMessageModel(
      id: json['id'],
      chatGroupId: json['chat_group_id'],
      userId: json['user_id'],
      message: json['message'] ?? '',
      imageUrl: imageUrl,
      isRead: (json['is_read'] ?? 0) == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: GroupChatUserModel.fromJson(json['user']),
    );
  }

  // Method to convert Message object to JSON (if needed for sending back)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_group_id': chatGroupId,
      'user_id': userId,
      'message': message,
      'image_url': imageUrl,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class GroupChatUserModel {
  int id;
  String name;
  String username;
  String profileImage;

  GroupChatUserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
  });

  // Factory method to create a User object from JSON
  factory GroupChatUserModel.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] != null
        ? json['profile_image'].toString().contains('http')
            ? json['profile_image']
            : ApiEndpoints.baseImageUrl + json['profile_image']
        : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';
    return GroupChatUserModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profileImage: profileImage,
    );
  }

  // Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profile_image': profileImage,
    };
  }
}
