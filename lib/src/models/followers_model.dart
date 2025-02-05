class FollowersResponse {
  final List<Follower> followers;

  FollowersResponse({required this.followers});

  factory FollowersResponse.fromJson(Map<String, dynamic> json) {
    var followersList = json['followers'] as List;
    List<Follower> followers =
        followersList.map((i) => Follower.fromJson(i)).toList();
    return FollowersResponse(followers: followers);
  }
}

class Follower {
  final int userId;
  final String username;
  final String? profileImage;
  final Pivot pivot;

  Follower({
    required this.userId,
    required this.username,
    this.profileImage,
    required this.pivot,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      userId: json['user_id'],
      username: json['username'] ?? '',
      profileImage: json['profile_image'] ?? '',
      pivot: Pivot.fromJson(json['pivot']),
    );
  }
}

class Pivot {
  final int followingId;
  final int followerId;
  final String createdAt;
  final String updatedAt;

  Pivot({
    required this.followingId,
    required this.followerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      followingId: json['following_id'],
      followerId: json['follower_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
