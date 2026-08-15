import '../model/startup_models.dart';
import '../model/team_chat_message.dart';

class TeamState {
  const TeamState({
    this.selectedCategoryIndex = 0,
    this.members = const [],
    this.chatMessages = const {},
    this.isTypingMap = const {},
    this.unreadCounts = const {},
    this.replyIndex = 0,
  });

  final int selectedCategoryIndex;
  final List<TeamMember> members;
  final Map<String, List<TeamChatMessage>> chatMessages;
  final Map<String, bool> isTypingMap;
  final Map<String, int> unreadCounts;
  final int replyIndex;

  bool isTypingFor(String name) => isTypingMap[name] ?? false;
  int unreadCountFor(String name) => unreadCounts[name] ?? 0;
  int get totalUnread => unreadCounts.values.fold(0, (a, b) => a + b);

  List<TeamMember> get filteredMembers {
    switch (selectedCategoryIndex) {
      case 1:
        return members
            .where((m) => m.badge == 'FOUNDER' || m.badge == 'CO-FOUNDER')
            .toList();
      case 2:
        return members.where((m) => m.badge == 'CORE TEAM').toList();
      case 3:
        return members
            .where((m) =>
                m.badge != 'FOUNDER' &&
                m.badge != 'CO-FOUNDER' &&
                m.badge != 'CORE TEAM')
            .toList();
      default:
        return members;
    }
  }

  TeamState copyWith({
    int? selectedCategoryIndex,
    List<TeamMember>? members,
    Map<String, List<TeamChatMessage>>? chatMessages,
    Map<String, bool>? isTypingMap,
    Map<String, int>? unreadCounts,
    int? replyIndex,
  }) {
    return TeamState(
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      members: members ?? this.members,
      chatMessages: chatMessages ?? this.chatMessages,
      isTypingMap: isTypingMap ?? this.isTypingMap,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      replyIndex: replyIndex ?? this.replyIndex,
    );
  }
}
