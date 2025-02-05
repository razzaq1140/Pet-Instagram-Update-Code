class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profileImage;
  final String username;
  final bool isPrivate;
  final String about;
  final String dogType;
  final String breed;
  final int age;
  final bool isActive;
  final double weight;
  final String createdAt;
  final String updatedAt;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.username,
    required this.isPrivate,
    required this.about,
    required this.dogType,
    required this.breed,
    required this.age,
    required this.isActive,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'] ??
          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
      username: json['username'] ?? '',
      isPrivate: json['is_private'] == 1,
      about: json['about'] ?? '',
      dogType: json['dog_type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      isActive: json['is_active'] == 1,
      weight: (json['weight'] ?? 0).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      isFollowing: json['is_following'],
    );
  }
}
