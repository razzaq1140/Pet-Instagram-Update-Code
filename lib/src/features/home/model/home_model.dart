class PostsModel {
  final String? category;
  final String userName;
  final String userImage;
  final List<String> postMedia;
  final String postTime;
  final String likes;
  final int comments;
  final String description;

  PostsModel({
    this.category,
    required this.userName,
    required this.userImage,
    required this.postMedia,
    required this.postTime,
    required this.likes,
    required this.comments,
    required this.description,
  });
}
