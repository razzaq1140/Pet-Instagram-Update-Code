import '/src/core/api_endpoints.dart';

class JoinedChatGroupModel {
  final int id;
  String name;
  bool isPrivate;
  bool isFavorite;
  bool isPinned;
  String description;
  String iconUrl;
  final int memberCount;
  final int unreadCount;
  final GroupCreator creator; // Added creator field

  JoinedChatGroupModel({
    required this.id,
    required this.name,
    required this.isPrivate,
    required this.isFavorite,
    required this.isPinned,
    required this.description,
    required this.iconUrl,
    required this.memberCount,
    required this.unreadCount,
    required this.creator, // Added creator parameter
  });

  // From JSON
  factory JoinedChatGroupModel.fromJson(Map<String, dynamic> json) {
    return JoinedChatGroupModel(
      id: json['id'],
      name: json['name'] ?? '',
      isPrivate: (json['is_private'] ?? 0) == 1,
      isFavorite: json['is_favorite'] ?? false,
      isPinned: json['is_pinned'] ?? false,
      description: json['description'] ?? '',
      iconUrl: _processIconUrl(json['icon_url']),
      memberCount: json['member_count'] ?? 1,
      unreadCount: json['unread_count'] ?? 0,
      creator:
          GroupCreator.fromJson(json['creator']), // Creating Creator from JSON
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

  // The copyWith method allows for copying an instance with modified fields
  JoinedChatGroupModel copyWith({
    int? id,
    String? name,
    bool? isPrivate,
    bool? isFavorite,
    bool? isPinned,
    String? description,
    String? iconUrl,
    int? memberCount,
    int? unreadCount,
    GroupCreator? creator,
  }) {
    return JoinedChatGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isPrivate: isPrivate ?? this.isPrivate,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      memberCount: memberCount ?? this.memberCount,
      unreadCount: unreadCount ?? this.unreadCount,
      creator: creator ?? this.creator,
    );
  }
}

class GroupCreator {
  final int id;
  final String name;
  final String email;
  final String profileImage;

  GroupCreator({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  // From JSON for the Creator object
  factory GroupCreator.fromJson(Map<String, dynamic> json) {
    String profileImage = json[''] ?? '';
    if (profileImage.isNotEmpty) {
      profileImage = ApiEndpoints.baseImageUrl + profileImage;
    }
    return GroupCreator(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: profileImage,
    );
  }
}
