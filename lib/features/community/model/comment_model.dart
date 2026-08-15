class PostComment {
  final String id;
  final String postId;
  final String authorName;
  final String text;
  final DateTime createdAt;
  final bool isLiked;

  const PostComment({
    required this.id,
    required this.postId,
    required this.authorName,
    required this.text,
    required this.createdAt,
    this.isLiked = false,
  });
}
