import '/src/core/api_endpoints.dart';

class GroupMemberModel {
  final int userId;
  final String name;
  final String email;
  final String profileImage;
  final MemberPivotModel pivot;

  GroupMemberModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.pivot,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    // Check if profile image is null, if so set default image URL
    String profileImageUrl = json['profile_image'] != null
        ? ApiEndpoints.baseImageUrl + json['profile_image']
        : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';

    return GroupMemberModel(
      userId: json['user_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: profileImageUrl,
      pivot: MemberPivotModel.fromJson(json['pivot']),
    );
  }
}

class MemberPivotModel {
  int chatGroupId;
  int userId;
  bool isAdmin;
  final String createdAt;
  final String updatedAt;

  MemberPivotModel({
    required this.chatGroupId,
    required this.userId,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberPivotModel.fromJson(Map<String, dynamic> json) {
    return MemberPivotModel(
      chatGroupId: json['chat_group_id'],
      userId: json['user_id'],
      isAdmin: (json['is_admin'] ?? 0) == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
