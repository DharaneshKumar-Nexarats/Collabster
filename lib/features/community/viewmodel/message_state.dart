import '../model/chat_model.dart';

class MessageState {
  const MessageState({
    this.conversations = const [],
    this.searchQuery = '',
    this.selectedFilter = 'All',
  });

  final List<Conversation> conversations;
  final String searchQuery;
  final String selectedFilter;

  int get totalUnread => conversations.fold(0, (sum, c) => sum + c.unreadCount);

  List<Conversation> get filteredConversations {
    final query = searchQuery.trim().toLowerCase();
    final filter = selectedFilter;

    return conversations.where((c) {
      if (query.isNotEmpty && !c.name.toLowerCase().contains(query)) {
        return false;
      }
      if (filter == 'Unread' && c.unreadCount == 0) return false;
      return true;
    }).toList();
  }

  MessageState copyWith({
    List<Conversation>? conversations,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return MessageState(
      conversations: conversations ?? this.conversations,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
