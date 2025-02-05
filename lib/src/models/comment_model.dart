class CommentModel {
  final int id;
  final String content;
  final String createdAt;
  final CommentUserModel user;
  bool likedByUser;

  CommentModel(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.user,
      required this.likedByUser});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'] ?? '',
      likedByUser: json['liked_by_user'],
      createdAt: json['created_at'],
      user: CommentUserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt,
      'user': user.toJson(),
      'liked_by_user': likedByUser,
    };
  }

  CommentModel copyWith({
    int? id,
    String? content,
    String? createdAt,
    CommentUserModel? user,
    bool? likedByUser,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      likedByUser: likedByUser ?? this.likedByUser,
    );
  }
}

class CommentUserModel {
  final int id;
  final String name;
  final String username;
  final String profileImage;

  CommentUserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] ??
        'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';
    if (profileImage.contains('storage')) {
      profileImage = profileImage.replaceAll('storage', 'public/uploads');
    }
    if (profileImage.contains('profile_images/profile_images/')) {
      profileImage = profileImage.replaceAll(
          'profile_images/profile_images/', 'profile_images/');
    }
    return CommentUserModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profileImage: profileImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profile_image': profileImage,
    };
  }
}
