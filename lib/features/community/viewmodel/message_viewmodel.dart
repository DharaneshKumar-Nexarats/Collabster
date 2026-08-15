import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/chat_model.dart';
import 'message_state.dart';

class MessageViewModel extends StateNotifier<MessageState> {
  MessageViewModel() : super(MessageState(conversations: _seed));

  static final List<Conversation> _seed = [
    Conversation(
      id: 'conv_1',
      name: 'Flutter Developers · General',
      subtitle: 'Have you seen the new Riverpod 3 update?',
      isRoom: true,
      isOnline: true,
      unreadCount: 2,
      messages: [
        ChatMessage(
          id: 'm1',
          text: 'Good morning everyone! The community meetup is next Friday.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ChatMessage(
          id: 'm2',
          text: 'I\'ll be there! Any agenda topics?',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 4, minutes: 30),
          ),
          isMine: true,
        ),
        ChatMessage(
          id: 'm3',
          text:
              'We\'ll cover state management patterns and a live code review.',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        ChatMessage(
          id: 'm4',
          text: 'Have you seen the new Riverpod 3 update?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ],
    ),
    Conversation(
      id: 'conv_2',
      name: 'Startup Founders · Investor Talks',
      subtitle: 'Can we sync before the investor meetup?',
      isRoom: true,
      isOnline: false,
      messages: [
        ChatMessage(
          id: 'm5',
          text: 'The pitch deck template is live in the shared drive.',
          timestamp: DateTime.now().subtract(const Duration(hours: 26)),
        ),
        ChatMessage(
          id: 'm6',
          text: 'Can we sync before the investor meetup?',
          timestamp: DateTime.now().subtract(const Duration(hours: 25)),
        ),
        ChatMessage(
          id: 'm7',
          text: 'Sure! Let\'s do Thursday 4 PM.',
          timestamp: DateTime.now().subtract(const Duration(hours: 24)),
          isMine: true,
        ),
      ],
    ),
    Conversation(
      id: 'conv_3',
      name: 'Sarah Lee',
      subtitle: 'Thanks for the feedback on my post!',
      isRoom: false,
      isOnline: true,
      unreadCount: 1,
      messages: [
        ChatMessage(
          id: 'm8',
          text: 'Loved your state management article!',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        ChatMessage(
          id: 'm9',
          text: 'Thank you Sarah! Glad it helped.',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 50),
          ),
          isMine: true,
        ),
        ChatMessage(
          id: 'm10',
          text: 'Thanks for the feedback on my post!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
        ),
      ],
    ),
    Conversation(
      id: 'conv_4',
      name: 'Rahul Verma',
      subtitle: 'The design tokens doc is ready 🎉',
      isRoom: false,
      isOnline: false,
      unreadCount: 3,
      messages: [
        ChatMessage(
          id: 'm11',
          text: 'The design tokens doc is ready 🎉',
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        ChatMessage(
          id: 'm12',
          text: 'Will review it today, thanks!',
          timestamp: DateTime.now().subtract(const Duration(hours: 7)),
          isMine: true,
        ),
      ],
    ),
    Conversation(
      id: 'conv_5',
      name: 'Mike Johnson',
      subtitle: 'Great point in the AI discussion',
      isRoom: false,
      isOnline: true,
      messages: [
        ChatMessage(
          id: 'm13',
          text: 'Great point in the AI discussion',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
        ChatMessage(
          id: 'm14',
          text: 'Thanks! Let\'s chat about it sometime.',
          timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
          isMine: true,
        ),
      ],
    ),
  ];

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void markRead(String conversationId) {
    final updated = state.conversations.map((c) {
      if (c.id != conversationId) return c;
      c.unreadCount = 0;
      return c;
    }).toList();
    state = state.copyWith(conversations: updated);
  }

  void sendMessage(
    String conversationId,
    String text, {
    String senderName = 'You',
  }) {
    if (text.trim().isEmpty) return;

    final message = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      timestamp: DateTime.now(),
      isMine: true,
    );

    final updated = state.conversations.map((c) {
      if (c.id != conversationId) return c;
      c.messages = [...c.messages, message];
      return c;
    }).toList();

    state = state.copyWith(conversations: updated);
  }
}
