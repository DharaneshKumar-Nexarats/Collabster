import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/event_model.dart';
import 'event_create_state.dart';

class EventCreateViewModel extends StateNotifier<EventCreateState> {
  EventCreateViewModel() : super(const EventCreateState());

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setIsOnline(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void setImageUrl(String? imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  Event? createEvent() {
    if (!state.isValid || state.startDate == null || state.endDate == null) {
      return null;
    }

    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: state.title,
      description: state.description,
      location: state.location,
      startDate: state.startDate!,
      endDate: state.endDate!,
      organizerName: 'You',
      category: state.category,
      isOnline: state.isOnline,
      imageUrl: state.imageUrl,
    );
  }

  void reset() {
    state = const EventCreateState();
  }
}
