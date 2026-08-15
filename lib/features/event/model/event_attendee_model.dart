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