import '../model/event_model.dart';

abstract class IEventRepository {
  List<Event> fetchEvents();

  List<EventAttendee> fetchAttendees(String eventId);

  void saveEvent(Event event);

  void saveRsvp(String eventId);
}
