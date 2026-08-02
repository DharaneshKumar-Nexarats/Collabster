import 'dart:async';
import 'package:flutter/foundation.dart';
import '../model/startup_models.dart';
import '../model/team_chat_message.dart';

class TeamViewModel extends ChangeNotifier {
  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  final Map<String, bool> _isTyping = {};
  bool isTypingFor(String name) => _isTyping[name] ?? false;

  final Map<String, int> _unreadCounts = {};
  int unreadCountFor(String name) => _unreadCounts[name] ?? 0;
  int get totalUnread => _unreadCounts.values.fold(0, (a, b) => a + b);

  final List<TeamMember> _members = [
    const TeamMember(
      name: 'Rahul Verma',
      role: 'Founder & CEO',
      department: 'Executive / Strategy',
      badge: 'FOUNDER',
      badgeColorKey: 'founder',
      initials: 'RV',
      email: 'rahul.verma@collabster.io',
    ),
    const TeamMember(
      name: 'Sneha Iyer',
      role: 'Co-Founder & CTO',
      department: 'Engineering / Tech',
      badge: 'CO-FOUNDER',
      badgeColorKey: 'cofounder',
      initials: 'SI',
      email: 'sneha.iyer@collabster.io',
    ),
    const TeamMember(
      name: 'Vikram Singh',
      role: 'Marketing Lead',
      department: 'Growth / Comms',
      badge: 'CORE TEAM',
      badgeColorKey: 'coreTeam',
      initials: 'VS',
      email: 'vikram.singh@collabster.io',
    ),
    const TeamMember(
      name: 'Anika Patel',
      role: 'Product Designer',
      department: 'Design / UX',
      badge: 'CORE TEAM',
      badgeColorKey: 'coreTeam',
      initials: 'AP',
      email: 'anika.patel@collabster.io',
    ),
  ];

  List<TeamMember> get allMembers => List.unmodifiable(_members);

  List<TeamMember> get filteredMembers {
    switch (_selectedCategoryIndex) {
      case 1:
        return _members
            .where((m) => m.badge == 'FOUNDER' || m.badge == 'CO-FOUNDER')
            .toList();
      case 2:
        return _members.where((m) => m.badge == 'CORE TEAM').toList();
      case 3:
        return _members
            .where((m) =>
                m.badge != 'FOUNDER' &&
                m.badge != 'CO-FOUNDER' &&
                m.badge != 'CORE TEAM')
            .toList();
      default:
        return _members;
    }
  }

  final Map<String, List<TeamChatMessage>> _chatMessages = {};

  static final Map<String, List<TeamChatMessage>> _starterMessages = {
    'Rahul Verma': [
      const TeamChatMessage(
        sender: 'Rahul Verma',
        text: 'Hey! How\'s everything going with the current sprint?',
        time: '9:00 AM',
        isMe: false,
        status: MessageStatus.seen,
      ),
      const TeamChatMessage(
        sender: 'You',
        text: 'Going well! Just finalizing the investor deck for next week.',
        time: '9:02 AM',
        isMe: true,
        status: MessageStatus.seen,
      ),
      const TeamChatMessage(
        sender: 'Rahul Verma',
        text: 'Great. Let me know if you need any data points from my end.',
        time: '9:04 AM',
        isMe: false,
        status: MessageStatus.seen,
      ),
    ],
    'Sneha Iyer': [
      const TeamChatMessage(
        sender: 'Sneha Iyer',
        text: 'The API latency issue is fixed in staging. Want me to push to prod?',
        time: '10:15 AM',
        isMe: false,
        status: MessageStatus.delivered,
      ),
      const TeamChatMessage(
        sender: 'You',
        text: 'Not yet — let QA finish by EOD first.',
        time: '10:18 AM',
        isMe: true,
        status: MessageStatus.seen,
      ),
    ],
    'Vikram Singh': [
      const TeamChatMessage(
        sender: 'Vikram Singh',
        text: 'LinkedIn campaign is live! First 6 hours — 420 impressions',
        time: 'Yesterday',
        isMe: false,
        status: MessageStatus.seen,
      ),
    ],
    'Anika Patel': [
      const TeamChatMessage(
        sender: 'Anika Patel',
        text: 'New onboarding flow mockups are uploaded to Figma. Please review!',
        time: 'Yesterday',
        isMe: false,
        status: MessageStatus.seen,
      ),
      const TeamChatMessage(
        sender: 'You',
        text: 'Looks clean — love the new color palette',
        time: 'Yesterday',
        isMe: true,
        status: MessageStatus.seen,
      ),
    ],
  };

  List<TeamChatMessage> getMessagesFor(String memberName) {
    if (!_chatMessages.containsKey(memberName)) {
      _chatMessages[memberName] =
          List.from(_starterMessages[memberName] ?? [
            TeamChatMessage(
              sender: memberName,
              text: 'Hello! Thanks for reaching out. How can I help?',
              time: '10:42 AM',
              isMe: false,
              status: MessageStatus.seen,
            ),
          ]);
    }
    return List.unmodifiable(_chatMessages[memberName]!);
  }

  TeamChatMessage? lastMessageFor(String memberName) {
    final msgs = _chatMessages[memberName] ??
        (_starterMessages[memberName] ?? []);
    if (msgs.isEmpty) return null;
    return msgs.last;
  }

  static const List<String> _autoReplies = [
    'Got it, thanks!',
    'Sure, will take a look right away.',
    'On it! Will update you shortly.',
    'That sounds good. Let\'s sync up later.',
    'Perfect, thanks for sharing!',
    'Noted. Will circle back with feedback.',
  ];

  int _replyIndex = 0;

  void sendMessage(String memberName, String text) {
    if (text.trim().isEmpty) return;
    getMessagesFor(memberName);

    _unreadCounts[memberName] = 0;

    final now = DateTime.now();
    final timeStr = _formatTime(now);
    _chatMessages[memberName]!.add(
      TeamChatMessage(
        sender: 'You',
        text: text.trim(),
        time: timeStr,
        isMe: true,
        status: MessageStatus.sent,
      ),
    );
    notifyListeners();

    Timer(const Duration(milliseconds: 800), () {
      _isTyping[memberName] = true;
      notifyListeners();

      Timer(const Duration(milliseconds: 2000), () {
        _isTyping[memberName] = false;
        final reply = _autoReplies[_replyIndex % _autoReplies.length];
        _replyIndex++;
        _chatMessages[memberName]!.add(
          TeamChatMessage(
            sender: memberName,
            text: reply,
            time: _formatTime(DateTime.now()),
            isMe: false,
            status: MessageStatus.delivered,
          ),
        );
        notifyListeners();
      });
    });
  }

  void addReaction(String memberName, int messageIndex, String emoji) {
    final msgs = _chatMessages[memberName];
    if (msgs == null || messageIndex >= msgs.length) return;
    final msg = msgs[messageIndex];
    final reactions = List<String>.from(msg.reactions);
    if (reactions.contains(emoji)) {
      reactions.remove(emoji);
    } else {
      reactions.add(emoji);
    }
    msgs[messageIndex] = msg.copyWith(reactions: reactions);
    notifyListeners();
  }

  void markAsRead(String memberName) {
    _unreadCounts[memberName] = 0;
    notifyListeners();
  }

  String _formatTime(DateTime dateTime) {
    final h = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final m = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void toggleFollow(TeamMember member) {
    final idx = _members.indexWhere((m) => m.name == member.name);
    if (idx != -1) {
      _members[idx] = _members[idx].copyWith(
        isFollowing: !_members[idx].isFollowing,
      );
      notifyListeners();
    }
  }

  void addMember(TeamMember member) {
    _members.add(member);
    notifyListeners();
  }
}
