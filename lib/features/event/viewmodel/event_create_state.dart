class EventCreateState {
  const EventCreateState({
    this.title = '',
    this.description = '',
    this.location = '',
    this.isOnline = false,
    this.category = 'Networking',
    this.startDate,
    this.endDate,
    this.imageUrl,
  });

  final String title;
  final String description;
  final String location;
  final bool isOnline;
  final String category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? imageUrl;

  bool get isValid => title.isNotEmpty && description.isNotEmpty && location.isNotEmpty;

  EventCreateState copyWith({
    String? title,
    String? description,
    String? location,
    bool? isOnline,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? imageUrl,
  }) {
    return EventCreateState(
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      isOnline: isOnline ?? this.isOnline,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
