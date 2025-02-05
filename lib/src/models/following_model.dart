class FollowingsResponse {
  final List<Following> followings;

  FollowingsResponse({required this.followings});

  factory FollowingsResponse.fromJson(Map<String, dynamic> json) {
    var followingList = json['following'] as List;
    List<Following> followings =
        followingList.map((i) => Following.fromJson(i)).toList();
    return FollowingsResponse(followings: followings);
  }
}

class Following {
  final int userId;
  final String username;
  final String? profileImage;
  final Pivot pivot;

  Following({
    required this.userId,
    required this.username,
    this.profileImage,
    required this.pivot,
  });

  factory Following.fromJson(Map<String, dynamic> json) {
    return Following(
      userId: json['user_id'],
      username: json['username'] ?? '',
      profileImage: json['profile_image'] ?? '',
      pivot: Pivot.fromJson(json['pivot']),
    );
  }
}

class Pivot {
  final int followerId;
  final int followingId;
  final String createdAt;
  final String updatedAt;

  Pivot({
    required this.followerId,
    required this.followingId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      followerId: json['follower_id'],
      followingId: json['following_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
