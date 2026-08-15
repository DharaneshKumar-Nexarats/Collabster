class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMine;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    this.isMine = false,
  });
}

class Conversation {
  final String id;
  final String name;
  final String subtitle;
  final bool isRoom;
  final bool isOnline;
  List<ChatMessage> messages;
  int unreadCount;

  Conversation({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.isRoom,
    required this.isOnline,
    required this.messages,
    this.unreadCount = 0,
  });

  ChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;

  String get timeLabel {
    final msg = lastMessage;
    if (msg == null) return '';
    final diff = DateTime.now().difference(msg.timestamp);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${msg.timestamp.day}/${msg.timestamp.month}';
  }
}
