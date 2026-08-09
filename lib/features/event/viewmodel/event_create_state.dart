class EventCreateState {
  const EventCreateState({
    this.title = '',
    this.description = '',
    this.location = '',
    this.isOnline = false,
    this.category = 'Networking',
    this.startDate,
    this.endDate,
  });

  final String title;
  final String description;
  final String location;
  final bool isOnline;
  final String category;
  final DateTime? startDate;
  final DateTime? endDate;

  bool get isValid => title.isNotEmpty && description.isNotEmpty && location.isNotEmpty;

  EventCreateState copyWith({
    String? title,
    String? description,
    String? location,
    bool? isOnline,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EventCreateState(
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      isOnline: isOnline ?? this.isOnline,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
