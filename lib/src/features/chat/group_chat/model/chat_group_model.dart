import 'package:pet_project/src/core/api_endpoints.dart';

class ChatGroupModel {
  final int id;
  final String name;
  final bool isPrivate;
  final String description;
  final String iconUrl;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GroupUserModel creator;

  ChatGroupModel({
    required this.id,
    required this.name,
    required this.isPrivate,
    required this.description,
    required this.iconUrl,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.creator,
  });

  // From JSON
  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
      id: json['id'],
      name: json['name'] ?? '',
      isPrivate: (json['is_private'] ?? 0) == 1,
      description: json['description'] ?? '',
      iconUrl: _processIconUrl(json['icon_url']),
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      creator: GroupUserModel.fromJson(json['creator']),
    );
  }

  // Process the icon URL: add 'public/uploads/' if it doesn't have 'public' in the URL
  static String _processIconUrl(String? iconUrl) {
    String url = iconUrl ?? '';

    if (url.contains('public')) {
      return url; // URL is already complete in JSON
    } else {
      final updatedUrl = url.replaceAll('uploads', 'public/uploads');
      return updatedUrl;
    }
  }
}

class GroupUserModel {
  final int id;
  final String name;
  final String email;
  final String profileImage;
  final String username;
  final String about;
  final String dogType;
  final String breed;
  final int age;
  final bool isActive;
  final double weight;
  final bool isPrivate;

  GroupUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.username,
    required this.about,
    required this.dogType,
    required this.breed,
    required this.age,
    required this.isActive,
    required this.weight,
    required this.isPrivate,
  });

  // From JSON
  factory GroupUserModel.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] != null
        ? json['profile_image'].toString().contains('http')
            ? json['profile_image']
            : ApiEndpoints.baseImageUrl + json['profile_image']
        : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';

    return GroupUserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: profileImage,
      username: json['username'] ?? '',
      about: json['about'] ?? '',
      dogType: json['dog_type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      isActive: json['is_active'] == 1, // Assuming 1 is true, 0 is false
      weight: json['weight']?.toDouble() ?? 0.0,
      isPrivate: json['is_private'] == null
          ? false
          : json['is_private'] == 1, // Null check for isPrivate
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'username': username,
      'about': about,
      'dog_type': dogType,
      'breed': breed,
      'age': age,
      'is_active': isActive ? 1 : 0,
      'weight': weight,
      'is_private': isPrivate ? 1 : 0,
    };
  }
}
