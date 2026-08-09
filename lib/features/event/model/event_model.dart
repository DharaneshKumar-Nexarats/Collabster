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

class EventAttendee {
  final String id;
  final String name;
  final String role;
  final String initials;
  final bool isGoing;

  const EventAttendee({
    required this.id,
    required this.name,
    required this.role,
    required this.initials,
    this.isGoing = true,
  });
}
