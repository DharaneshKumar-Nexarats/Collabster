import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/comment_model.dart';
import '../model/post_model.dart';
import 'post_state.dart';

class PostViewModel extends StateNotifier<PostState> {
  PostViewModel() : super(const PostState());

  void loadPosts() {
    if (state.posts.isNotEmpty) return;
    state = state.copyWith(
      posts: [
        CareerPost(
          id: '1',
          title: 'Best practices for Flutter state management',
          content:
              'I\'ve been working with Flutter for 2 years and wanted to share my thoughts on state management approaches. I\'ve tried setState, Provider, Riverpod, and Bloc across several production apps. The key insight: pick the simplest solution that scales with your team size. For small apps, setState with InheritedWidget is enough. For medium apps, Riverpod with code generation gives the best developer experience. For large teams, you need explicit architecture like Bloc. What has worked best for you?',
          authorName: 'Sarah Chen',
          authorRole: 'Senior Developer',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          likes: 42,
          comments: 4,
        ),
        CareerPost(
          id: '2',
          title: 'Design Systems best practices',
          content:
              'Building a scalable design system for mobile apps - want to discuss what works and what doesn\'t. We found that token-driven theming with light and dark mode support early on saved us months of refactoring later. Component documentation and a playground app are non-negotiable.',
          authorName: 'Rahul Verma',
          authorRole: 'Product Designer',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          likes: 22,
          comments: 6,
        ),
        CareerPost(
          id: '3',
          title: 'How we scaled our startup to 10K users',
          content:
              'Sharing our growth journey - from a small MVP to a thriving community. Key takeaways: ship fast, listen to feedback loops, and don\'t be afraid to pivot your monetization model.',
          authorName: 'Ananya Rao',
          authorRole: 'Founder',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          likes: 15,
          comments: 3,
        ),
      ],
      comments: [
        PostComment(
          id: 'c1',
          postId: '1',
          authorName: 'Rahul Verma',
          text:
              'Great writeup! I\'ve found Riverpod to be the sweet spot for most projects.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        PostComment(
          id: 'c2',
          postId: '1',
          authorName: 'Ananya Rao',
          text:
              'Completely agree on the team-size point. Architecture should follow team maturity.',
          createdAt: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 30),
          ),
          isLiked: true,
        ),
        PostComment(
          id: 'c3',
          postId: '1',
          authorName: 'Mike Johnson',
          text:
              'Bookmarked this. Would love a follow-up post on Riverpod codegen setup.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        PostComment(
          id: 'c4',
          postId: '1',
          authorName: 'Sara Ali',
          text:
              'What about testing? How do you structure widget tests for Riverpod?',
          createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
        PostComment(
          id: 'c5',
          postId: '2',
          authorName: 'Sara Ali',
          text: 'Token-driven theming saved our team too. Great point.',
          createdAt: DateTime.now().subtract(const Duration(hours: 20)),
        ),
        PostComment(
          id: 'c6',
          postId: '2',
          authorName: 'Mike Johnson',
          text: 'Would love to see a companion article on dark mode handling.',
          createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        ),
        PostComment(
          id: 'c7',
          postId: '3',
          authorName: 'Rahul Verma',
          text: 'Inspiring journey! Keep sharing these updates.',
          createdAt: DateTime.now().subtract(
            const Duration(days: 1, hours: 20),
          ),
        ),
      ],
      unreadCount: 1,
    );
  }

  void setPostType(String type) {
    state = state.copyWith(selectedPostType: type);
  }

  void toggleLike(String postId) {
    final updated = state.posts.map((post) {
      if (post.id != postId) return post;
      return CareerPost(
        id: post.id,
        title: post.title,
        content: post.content,
        authorName: post.authorName,
        authorRole: post.authorRole,
        createdAt: post.createdAt,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        comments: post.comments,
        isLiked: !post.isLiked,
      );
    }).toList();
    state = state.copyWith(posts: updated);
  }

  void updateTitle(String title) {
    state = state.copyWith(hasTitle: title.isNotEmpty);
  }

  void updateContent(String content) {
    state = state.copyWith(hasContent: content.isNotEmpty);
  }

  void submitPost(
    String title,
    String content,
    String communityId, {
    String authorName = 'You',
  }) {
    if (title.isEmpty || content.isEmpty) return;

    final newPost = CareerPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      authorName: authorName,
      authorRole: 'Member',
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      posts: [newPost, ...state.posts],
      hasTitle: false,
      hasContent: false,
    );
  }

  void addComment(String postId, String text, {String authorName = 'You'}) {
    if (text.trim().isEmpty) return;

    final comment = PostComment(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      authorName: authorName,
      text: text.trim(),
      createdAt: DateTime.now(),
    );

    final updatedPosts = state.posts.map((post) {
      if (post.id != postId) return post;
      return CareerPost(
        id: post.id,
        title: post.title,
        content: post.content,
        authorName: post.authorName,
        authorRole: post.authorRole,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments + 1,
        isLiked: post.isLiked,
      );
    }).toList();

    state = state.copyWith(
      posts: updatedPosts,
      comments: [comment, ...state.comments],
    );
  }

  void markPostsAsRead() {
    state = state.copyWith(unreadCount: 0);
  }
}
