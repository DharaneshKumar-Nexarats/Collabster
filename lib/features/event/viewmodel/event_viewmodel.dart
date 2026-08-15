import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/event_model.dart';
import '../repository/i_event_repository.dart';
import 'event_state.dart';

class EventViewModel extends StateNotifier<EventState> {
  final IEventRepository _repository;

  EventViewModel(this._repository) : super(const EventState());

  void loadEvents() {
    if (state.events.isNotEmpty) return;
    state = state.copyWith(
      events: _repository.fetchEvents(),
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
    final event = state.events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => Event(
        id: eventId,
        title: '',
        description: '',
        location: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        organizerName: '',
        category: '',
      ),
    );
    if (state.myEvents.any((e) => e.id == eventId)) return;
    _repository.saveRsvp(eventId);
    state = state.copyWith(myEvents: [...state.myEvents, event]);
  }

  void cancelRsvp(String eventId) {
    state = state.copyWith(
      myEvents: state.myEvents.where((e) => e.id != eventId).toList(),
    );
  }

  bool isRegistered(String eventId) =>
      state.myEvents.any((e) => e.id == eventId);

  void addEvent(Event event) {
    _repository.saveEvent(event);
    state = state.copyWith(events: [event, ...state.events]);
  }

  void markEventsAsRead() {
    state = state.copyWith(unreadCount: 0);
  }
}