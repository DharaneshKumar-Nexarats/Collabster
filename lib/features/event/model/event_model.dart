export 'event_attendee_model.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String organizerName;
  final String category;
  final int attendeeCount;
  final bool isOnline;
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.organizerName,
    required this.category,
    this.attendeeCount = 0,
    this.isOnline = false,
    this.imageUrl,
  });
}
