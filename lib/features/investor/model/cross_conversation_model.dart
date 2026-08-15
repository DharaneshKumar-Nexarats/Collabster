/// Cross-mode conversation between any two users (Startup founder, Investor, etc.)
class CrossConversation {
  final String id;
  final String participant1Id;
  final String participant1Name;
  final String participant1Role; // 'startup' | 'investor' | 'career' | 'community'
  final String participant1Avatar;
  final String participant2Id;
  final String participant2Name;
  final String participant2Role;
  final String participant2Avatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const CrossConversation({
    required this.id,
    required this.participant1Id,
    required this.participant1Name,
    required this.participant1Role,
    required this.participant1Avatar,
    required this.participant2Id,
    required this.participant2Name,
    required this.participant2Role,
    required this.participant2Avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  CrossConversation copyWith({
    String? id,
    String? participant1Id,
    String? participant1Name,
    String? participant1Role,
    String? participant1Avatar,
    String? participant2Id,
    String? participant2Name,
    String? participant2Role,
    String? participant2Avatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isOnline,
  }) {
    return CrossConversation(
      id: id ?? this.id,
      participant1Id: participant1Id ?? this.participant1Id,
      participant1Name: participant1Name ?? this.participant1Name,
      participant1Role: participant1Role ?? this.participant1Role,
      participant1Avatar: participant1Avatar ?? this.participant1Avatar,
      participant2Id: participant2Id ?? this.participant2Id,
      participant2Name: participant2Name ?? this.participant2Name,
      participant2Role: participant2Role ?? this.participant2Role,
      participant2Avatar: participant2Avatar ?? this.participant2Avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

/// Cross-mode message
class CrossMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String senderAvatar;
  final String text;
  final DateTime createdAt;
  final bool isRead;

  const CrossMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    this.senderAvatar = '',
    required this.text,
    required this.createdAt,
    this.isRead = false,
  });
}