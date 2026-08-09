import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/post_model.dart';
import 'post_state.dart';

class PostViewModel extends StateNotifier<PostState> {
  PostViewModel() : super(const PostState());

  void loadPosts() {
    state = state.copyWith(
      posts: [
        CareerPost(
          id: '1',
          title: 'Best practices for Flutter state management',
          content: 'I\'ve been working with Flutter for 2 years and wanted to share my thoughts on state management approaches...',
          authorName: 'Sarah Chen',
          authorRole: 'Senior Developer',
          createdAt: DateTime(2024, 8, 1),
          likes: 42,
          comments: 12,
        ),
      ],
    );
  }

  void setPostType(String type) {
    state = state.copyWith(selectedPostType: type);
  }

  void updateTitle(String title) {
    state = state.copyWith(hasTitle: title.isNotEmpty);
  }

  void updateContent(String content) {
    state = state.copyWith(hasContent: content.isNotEmpty);
  }

  void submitPost(String title, String content, String communityId) {
    if (title.isEmpty || content.isEmpty) return;

    final newPost = CareerPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      authorName: 'You',
      authorRole: 'Member',
      createdAt: DateTime.now(),
    );

    state = state.copyWith(posts: [newPost, ...state.posts]);
  }
}
