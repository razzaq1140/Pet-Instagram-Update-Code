class ChatRoomModel {
  final int chatRoomId;
  final ChatRoomOtherUserModel otherUser;
  final String latestMessage;
  final DateTime lastUpdated;

  ChatRoomModel({
    required this.chatRoomId,
    required this.otherUser,
    required this.latestMessage,
    required this.lastUpdated,
  });

  // Factory constructor to create an instance from a map (e.g., from JSON)
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatRoomId: json['chat_room_id'],
      otherUser: ChatRoomOtherUserModel.fromJson(json['other_user']),
      latestMessage: json['latest_message'] ?? '',
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  // Method to convert the object to a map (for saving or sending data)
  Map<String, dynamic> toMap() {
    return {
      'chat_room_id': chatRoomId,
      'other_user': otherUser.toMap(),
      'latest_message': latestMessage,
      'last_updated': lastUpdated,
    };
  }
}

class ChatRoomOtherUserModel {
  final int id;
  final String name;
  final String username;
  final String profileImage; // This can be null

  ChatRoomOtherUserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
  });

  // Factory constructor to create an instance from a map (e.g., from JSON)
  factory ChatRoomOtherUserModel.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] ??
        'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';
    if (!profileImage.contains('public')) {
      profileImage = profileImage.replaceAll('uploads', 'public/uploads');
    }

    return ChatRoomOtherUserModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profileImage: profileImage,
    );
  }

  // Method to convert the object to a map (for saving or sending data)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profile_image': profileImage,
    };
  }
}
