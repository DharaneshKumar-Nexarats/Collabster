enum MessageStatus { sent, delivered, seen }

class TeamChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMe;
  final MessageStatus status;
  final List<String> reactions;
  final bool isTyping;

  const TeamChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
    this.status = MessageStatus.sent,
    this.reactions = const [],
    this.isTyping = false,
  });

  TeamChatMessage copyWith({
    String? sender,
    String? text,
    String? time,
    bool? isMe,
    MessageStatus? status,
    List<String>? reactions,
    bool? isTyping,
  }) {
    return TeamChatMessage(
      sender: sender ?? this.sender,
      text: text ?? this.text,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      status: status ?? this.status,
      reactions: reactions ?? this.reactions,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
