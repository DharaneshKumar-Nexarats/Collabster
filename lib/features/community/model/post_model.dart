class CareerPost {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorRole;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;

  CareerPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorRole,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });
}
