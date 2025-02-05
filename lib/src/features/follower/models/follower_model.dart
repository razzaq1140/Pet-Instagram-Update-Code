import '/src/core/api_endpoints.dart';

class FollowerModel {
  final int userId;
  final String username;
  final String profileImage;
  final PivotModel pivot;

  FollowerModel({
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.pivot,
  });

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    // Check if profile image is null, if so set default image URL
    String profileImageUrl = json['profile_image'] != null
        ? ApiEndpoints.baseImageUrl + json['profile_image']
        : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';

    return FollowerModel(
      userId: json['user_id'],
      username: json['username'] ?? '',
      profileImage: profileImageUrl,
      pivot: PivotModel.fromJson(json['pivot']),
    );
  }
}

class PivotModel {
  final int followingId;
  final int followerId;
  final String createdAt;
  final String updatedAt;

  PivotModel({
    required this.followingId,
    required this.followerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PivotModel.fromJson(Map<String, dynamic> json) {
    return PivotModel(
      followingId: json['following_id'],
      followerId: json['follower_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
