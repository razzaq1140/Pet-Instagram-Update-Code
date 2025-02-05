class MessageModel {
  String token;
  NotificationModel notification;

  MessageModel({
    required this.token,
    required this.notification,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'notification': notification.toJson(),
      };
}

class NotificationModel {
  String title;
  String body;

  NotificationModel({
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };
}
