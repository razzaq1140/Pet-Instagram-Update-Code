class OtherUserProfile {
  final int id;
  final String? username;
  final String? profileImage;
  final String? about;
  final String? dogType;
  final String? breed;
  final int? age;
  final double? weight;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  OtherUserProfile({
    required this.id,
    this.username,
    this.profileImage,
    this.about,
    this.dogType,
    this.breed,
    this.age,
    this.weight,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  factory OtherUserProfile.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] ?? '';
    if (profileImage.isNotEmpty) {
      if (profileImage.contains('storage')) {
        profileImage = profileImage.replaceAll('storage', 'public/uploads');
      }
    }

    return OtherUserProfile(
      id: json['id'],
      username: json['username'] ?? '',
      profileImage: profileImage,
      about: json['about'] ?? '',
      dogType: json['dog_type'],
      breed: json['breed'],
      age: json['age'],
      weight: json['weight'] != null
          ? double.tryParse(json['weight'].toString())
          : null,
      postsCount: json['posts_count'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
    );
  }
}
