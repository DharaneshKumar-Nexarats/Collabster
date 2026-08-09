import '../model/post_model.dart';

class PostState {
  const PostState({
    this.posts = const [],
    this.selectedPostType = 'Discussion',
    this.hasTitle = false,
    this.hasContent = false,
  });

  final List<CareerPost> posts;
  final String selectedPostType;
  final bool hasTitle;
  final bool hasContent;

  PostState copyWith({
    List<CareerPost>? posts,
    String? selectedPostType,
    bool? hasTitle,
    bool? hasContent,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      selectedPostType: selectedPostType ?? this.selectedPostType,
      hasTitle: hasTitle ?? this.hasTitle,
      hasContent: hasContent ?? this.hasContent,
    );
  }
}
