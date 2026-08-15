import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/event_model.dart';
import 'event_state.dart';

class EventViewModel extends StateNotifier<EventState> {
  EventViewModel() : super(const EventState());

  void loadEvents() {
    if (state.events.isNotEmpty) return;
    state = state.copyWith(
      events: [
        Event(
          id: '1',
          title: 'Tech Startup Meetup',
          description: 'Network with founders and investors',
          location: 'Bangalore',
          startDate: DateTime(2024, 8, 15),
          endDate: DateTime(2024, 8, 15),
          organizerName: 'Tech Community',
          category: 'Networking',
          attendeeCount: 120,
        ),
        Event(
          id: '2',
          title: 'Flutter Workshop',
          description: 'Learn advanced Flutter techniques',
          location: 'Online',
          startDate: DateTime(2024, 8, 20),
          endDate: DateTime(2024, 8, 20),
          organizerName: 'Flutter Community',
          category: 'Workshop',
          attendeeCount: 250,
          isOnline: true,
        ),
      ],
      unreadCount: 2,
    );
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void rsvpEvent(String eventId) {
    final event = state.events.firstWhere((e) => e.id == eventId);
    if (!state.myEvents.any((e) => e.id == eventId)) {
      state = state.copyWith(myEvents: [...state.myEvents, event]);
    }
  }

  void addEvent(Event event) {
    state = state.copyWith(events: [event, ...state.events]);
  }

  void markEventsAsRead() {
    state = state.copyWith(unreadCount: 0);
  }
}
