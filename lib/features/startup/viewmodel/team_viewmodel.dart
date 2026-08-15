import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import '../model/team_chat_message.dart';
import 'team_state.dart';

class TeamViewModel extends StateNotifier<TeamState> {
  TeamViewModel() : super(const TeamState());

  static const Map<String, List<TeamChatMessage>> _starterMessages = {
    'Rahul Verma': [
      TeamChatMessage(
        sender: 'Rahul Verma',
        text: 'Hey! How\'s everything going with the current sprint?',
        time: '9:00 AM',
        isMe: false,
        status: MessageStatus.seen,
      ),
      TeamChatMessage(
        sender: 'You',
        text: 'Going well! Just finalizing the investor deck for next week.',
        time: '9:02 AM',
        isMe: true,
        status: MessageStatus.seen,
      ),
      TeamChatMessage(
        sender: 'Rahul Verma',
        text: 'Great. Let me know if you need any data points from my end.',
        time: '9:04 AM',
        isMe: false,
        status: MessageStatus.seen,
      ),
    ],
    'Sneha Iyer': [
      TeamChatMessage(
        sender: 'Sneha Iyer',
        text: 'The API latency issue is fixed in staging.',
        time: '10:15 AM',
        isMe: false,
        status: MessageStatus.delivered,
      ),
      TeamChatMessage(
        sender: 'You',
        text: 'Not yet — let QA finish by EOD first.',
        time: '10:18 AM',
        isMe: true,
        status: MessageStatus.seen,
      ),
    ],
    'Vikram Singh': [
      TeamChatMessage(
        sender: 'Vikram Singh',
        text: 'LinkedIn campaign is live! First 6 hours — 420 impressions',
        time: 'Yesterday',
        isMe: false,
        status: MessageStatus.seen,
      ),
    ],
    'Anika Patel': [
      TeamChatMessage(
        sender: 'Anika Patel',
        text: 'New onboarding flow mockups are uploaded to Figma.',
        time: 'Yesterday',
        isMe: false,
        status: MessageStatus.seen,
      ),
      TeamChatMessage(
        sender: 'You',
        text: 'Looks clean — love the new color palette',
        time: 'Yesterday',
        isMe: true,
        status: MessageStatus.seen,
      ),
    ],
  };

  static const List<String> _autoReplies = [
    'Got it, thanks!',
    'Sure, will take a look right away.',
    'On it! Will update you shortly.',
    'That sounds good. Let\'s sync up later.',
    'Perfect, thanks for sharing!',
    'Noted. Will circle back with feedback.',
  ];

  void loadInitialData() {
    state = state.copyWith(
      members: const [
        TeamMember(
          name: 'Rahul Verma',
          role: 'Founder & CEO',
          department: 'Executive / Strategy',
          badge: 'FOUNDER',
          badgeColorKey: 'founder',
          initials: 'RV',
          email: 'rahul.verma@collabster.io',
        ),
        TeamMember(
          name: 'Sneha Iyer',
          role: 'Co-Founder & CTO',
          department: 'Engineering / Tech',
          badge: 'CO-FOUNDER',
          badgeColorKey: 'cofounder',
          initials: 'SI',
          email: 'sneha.iyer@collabster.io',
        ),
        TeamMember(
          name: 'Vikram Singh',
          role: 'Marketing Lead',
          department: 'Growth / Comms',
          badge: 'CORE TEAM',
          badgeColorKey: 'coreTeam',
          initials: 'VS',
          email: 'vikram.singh@collabster.io',
        ),
        TeamMember(
          name: 'Anika Patel',
          role: 'Product Designer',
          department: 'Design / UX',
          badge: 'CORE TEAM',
          badgeColorKey: 'coreTeam',
          initials: 'AP',
          email: 'anika.patel@collabster.io',
        ),
      ],
    );
  }

  List<TeamChatMessage> getMessagesFor(String memberName) {
    if (!state.chatMessages.containsKey(memberName)) {
      final messages = _starterMessages[memberName] ?? [
        TeamChatMessage(
          sender: memberName,
          text: 'Hello! Thanks for reaching out. How can I help?',
          time: '10:42 AM',
          isMe: false,
          status: MessageStatus.seen,
        ),
      ];
      final updatedMessages = Map<String, List<TeamChatMessage>>.from(state.chatMessages);
      updatedMessages[memberName] = List.from(messages);
      state = state.copyWith(chatMessages: updatedMessages);
    }
    return List.unmodifiable(state.chatMessages[memberName]!);
  }

  TeamChatMessage? lastMessageFor(String memberName) {
    final msgs = state.chatMessages[memberName] ??
        (_starterMessages[memberName] ?? []);
    if (msgs.isEmpty) return null;
    return msgs.last;
  }

  void sendMessage(String memberName, String text) {
    if (text.trim().isEmpty) return;
    getMessagesFor(memberName);

    final now = DateTime.now();
    final timeStr = _formatTime(now);

    final newMessage = TeamChatMessage(
      sender: 'You',
      text: text.trim(),
      time: timeStr,
      isMe: true,
      status: MessageStatus.sent,
    );

    final updatedMessages = Map<String, List<TeamChatMessage>>.from(state.chatMessages);
    updatedMessages[memberName] = [...updatedMessages[memberName]!, newMessage];

    final updatedUnread = Map<String, int>.from(state.unreadCounts);
    updatedUnread[memberName] = 0;

    state = state.copyWith(
      chatMessages: updatedMessages,
      unreadCounts: updatedUnread,
    );

    Timer(const Duration(milliseconds: 800), () {
      final updatedTyping = Map<String, bool>.from(state.isTypingMap);
      updatedTyping[memberName] = true;
      state = state.copyWith(isTypingMap: updatedTyping);

      Timer(const Duration(milliseconds: 2000), () {
        final updatedTyping2 = Map<String, bool>.from(state.isTypingMap);
        updatedTyping2[memberName] = false;

        final reply = _autoReplies[state.replyIndex % _autoReplies.length];
        final updatedMessages2 = Map<String, List<TeamChatMessage>>.from(state.chatMessages);
        updatedMessages2[memberName] = [
          ...updatedMessages2[memberName]!,
          TeamChatMessage(
            sender: memberName,
            text: reply,
            time: _formatTime(DateTime.now()),
            isMe: false,
            status: MessageStatus.delivered,
          ),
        ];

        state = state.copyWith(
          isTypingMap: updatedTyping2,
          chatMessages: updatedMessages2,
          replyIndex: state.replyIndex + 1,
        );
      });
    });
  }

  void addReaction(String memberName, int messageIndex, String emoji) {
    final msgs = state.chatMessages[memberName];
    if (msgs == null || messageIndex >= msgs.length) return;
    final msg = msgs[messageIndex];
    final reactions = List<String>.from(msg.reactions);
    if (reactions.contains(emoji)) {
      reactions.remove(emoji);
    } else {
      reactions.add(emoji);
    }

    final updatedMessages = Map<String, List<TeamChatMessage>>.from(state.chatMessages);
    final updatedMsgs = List<TeamChatMessage>.from(updatedMessages[memberName]!);
    updatedMsgs[messageIndex] = msg.copyWith(reactions: reactions);
    updatedMessages[memberName] = updatedMsgs;

    state = state.copyWith(chatMessages: updatedMessages);
  }

  void markAsRead(String memberName) {
    final updatedUnread = Map<String, int>.from(state.unreadCounts);
    updatedUnread[memberName] = 0;
    state = state.copyWith(unreadCounts: updatedUnread);
  }

  String _formatTime(DateTime dateTime) {
    final h = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final m = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  void selectCategory(int index) {
    state = state.copyWith(selectedCategoryIndex: index);
  }

  void toggleFollow(TeamMember member) {
    final updated = state.members.map((m) {
      if (m.name == member.name) {
        return m.copyWith(isFollowing: !m.isFollowing);
      }
      return m;
    }).toList();
    state = state.copyWith(members: updated);
  }

  void addMember(TeamMember member) {
    state = state.copyWith(members: [...state.members, member]);
  }
}
