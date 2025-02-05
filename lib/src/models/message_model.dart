class Message {
  final String text;
  final String? imageUrl;
  final String? voiceUrl;
  final bool isSender;

  Message({
    required this.text,
    this.imageUrl,
    this.voiceUrl,
    required this.isSender,
  });
}