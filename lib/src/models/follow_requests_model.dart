class FollowerDetails {
  final int id;
  final String username;
  final String? profileImage;

  FollowerDetails({
    required this.id,
    required this.username,
    this.profileImage,
  });

  factory FollowerDetails.fromJson(Map<String, dynamic> json) {
    return FollowerDetails(
      id: json['id'],
      username: json['username'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}

class FollowRequest {
  final int id;
  final int userId;
  final int followerId;
  final String status;
  final FollowerDetails follower;

  FollowRequest({
    required this.id,
    required this.userId,
    required this.followerId,
    required this.status,
    required this.follower,
  });

  factory FollowRequest.fromJson(Map<String, dynamic> json) {
    return FollowRequest(
      id: json['id'],
      userId: json['user_id'],
      followerId: json['follower_id'],
      status: json['status'],
      follower: FollowerDetails.fromJson(json['follower']),
    );
  }
}

class FollowRequestsResponse {
  final String message;
  final List<FollowRequest> followRequests;

  FollowRequestsResponse({
    required this.message,
    required this.followRequests,
  });

  factory FollowRequestsResponse.fromJson(Map<String, dynamic> json) {
    var requestsList = json['follow_requests'] as List;
    List<FollowRequest> followRequests =
        requestsList.map((i) => FollowRequest.fromJson(i)).toList();
    return FollowRequestsResponse(
      message: json['message'],
      followRequests: followRequests,
    );
  }
}
