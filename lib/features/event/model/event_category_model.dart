class EventCategory {
  final String id;
  final String label;
  final String iconKey;

  const EventCategory({
    required this.id,
    required this.label,
    required this.iconKey,
  });
}

/// Catalog of event categories surfaced by the Event hub.
const List<EventCategory> eventCategories = [
  EventCategory(id: 'hackathon', label: 'Hackathon', iconKey: 'code'),
  EventCategory(id: 'workshop', label: 'Workshop', iconKey: 'workshop'),
  EventCategory(id: 'meetup', label: 'Meetup', iconKey: 'groups'),
  EventCategory(id: 'conference', label: 'Conference', iconKey: 'mic'),
  EventCategory(id: 'webinar', label: 'Webinar', iconKey: 'webinar'),
  EventCategory(id: 'networking', label: 'Networking', iconKey: 'handshake'),
];