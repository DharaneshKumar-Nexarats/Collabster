class EventFilter {
  final String label;
  final bool Function(String category, bool isOnline) matches;

  const EventFilter({required this.label, required this.matches});
}

/// Preset filters used by the Event hub and category screens.
final List<EventFilter> eventFilters = [
  EventFilter(label: 'All', matches: (_, __) => true),
  EventFilter(
    label: 'Online',
    matches: (_, isOnline) => isOnline,
  ),
  EventFilter(
    label: 'Offline',
    matches: (_, isOnline) => !isOnline,
  ),
  EventFilter(
    label: '24-Hour',
    matches: (category, _) => category == 'Hackathon',
  ),
];