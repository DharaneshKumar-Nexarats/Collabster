import '../model/comment_model.dart';
import '../model/post_model.dart';

class PostState {
  const PostState({
    this.posts = const [],
    this.comments = const [],
    this.selectedPostType = 'Discussion',
    this.hasTitle = false,
    this.hasContent = false,
    this.unreadCount = 1,
  });

  final List<CareerPost> posts;
  final List<PostComment> comments;
  final String selectedPostType;
  final bool hasTitle;
  final bool hasContent;
  final int unreadCount;

  PostState copyWith({
    List<CareerPost>? posts,
    List<PostComment>? comments,
    String? selectedPostType,
    bool? hasTitle,
    bool? hasContent,
    int? unreadCount,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      selectedPostType: selectedPostType ?? this.selectedPostType,
      hasTitle: hasTitle ?? this.hasTitle,
      hasContent: hasContent ?? this.hasContent,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
