import 'cross_conversation_model.dart';

class CrossConversationState {
  const CrossConversationState({
    this.conversations = const [],
    this.currentConversationId,
    this.messages = const [],
  });

  final List<CrossConversation> conversations;
  final String? currentConversationId;
  final List<CrossMessage> messages;

  CrossConversation? get currentConversation =>
      currentConversationId != null
          ? conversations.firstWhere((c) => c.id == currentConversationId)
          : null;

  List<CrossMessage> get currentMessages =>
      currentConversationId != null
          ? messages.where((m) => m.conversationId == currentConversationId).toList()
          : const [];

  CrossConversationState copyWith({
    List<CrossConversation>? conversations,
    String? currentConversationId,
    List<CrossMessage>? messages,
  }) {
    return CrossConversationState(
      conversations: conversations ?? this.conversations,
      currentConversationId: currentConversationId ?? this.currentConversationId,
      messages: messages ?? this.messages,
    );
  }
}