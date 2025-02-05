class ChatMessageModel {
  final int id;
  final int senderId;
  final int recipientId;
  final String? message;
  final String? image;
  final bool isRead;
  final DateTime createdAt;
  final ChatMessageSenderModel sender;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.image,
    required this.isRead,
    required this.createdAt,
    required this.sender,
  });

  // Factory method to create a ChatMessage object from JSON
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    String? image = json['image'];
    if (image != null && !image.contains('public')) {
      image = image.replaceAll('uploads', 'public/uploads');
    }

    return ChatMessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      recipientId: json['recipient_id'],
      message: json['message'],
      image: image,
      isRead: json['is_read'] == 1, // Converting integer to bool
      createdAt: DateTime.parse(json['created_at']),
      sender: ChatMessageSenderModel.fromJson(json['sender']),
    );
  }

  // Method to convert ChatMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'recipient_id': recipientId,
      'message': message,
      'image': image,
      'is_read': isRead ? 1 : 0, // Converting bool to integer
      'created_at': createdAt.toString(), // Converting DateTime to string
      'sender': sender.toJson(),
    };
  }
}

class ChatMessageSenderModel {
  final int id;
  final String name;
  final String username;
  final String profileImage;

  ChatMessageSenderModel({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
  });

  // Factory method to create a Sender object from JSON
  factory ChatMessageSenderModel.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] ??
        'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';
    if (!profileImage.contains('public')) {
      profileImage = profileImage.replaceAll('uploads', 'public/uploads');
    }
    return ChatMessageSenderModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profileImage: profileImage,
    );
  }

  // Method to convert Sender to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profile_image': profileImage,
    };
  }
}
