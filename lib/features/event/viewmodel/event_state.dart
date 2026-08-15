import '../model/event_model.dart';

class EventState {
  const EventState({
    this.events = const [],
    this.myEvents = const [],
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.unreadCount = 2,
  });

  final List<Event> events;
  final List<Event> myEvents;
  final String selectedFilter;
  final String searchQuery;
  final int unreadCount;

  List<Event> get filteredEvents {
    return events.where((e) {
      if (selectedFilter != 'All' && e.category != selectedFilter) return false;
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return e.title.toLowerCase().contains(query) ||
            e.location.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  EventState copyWith({
    List<Event>? events,
    List<Event>? myEvents,
    String? selectedFilter,
    String? searchQuery,
    int? unreadCount,
  }) {
    return EventState(
      events: events ?? this.events,
      myEvents: myEvents ?? this.myEvents,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
