import 'notification_model.dart';

class EventNotificationState {
  const EventNotificationState({
    this.notifications = const [],
    this.selectedFilter,
  });

  final List<EventNotification> notifications;
  final EventNotificationType? selectedFilter;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<EventNotification> get filteredNotifications {
    if (selectedFilter == null) return notifications;
    return notifications.where((n) => n.type == selectedFilter).toList();
  }

  EventNotificationState copyWith({
    List<EventNotification>? notifications,
    EventNotificationType? selectedFilter,
    bool clearFilter = false,
  }) {
    return EventNotificationState(
      notifications: notifications ?? this.notifications,
      selectedFilter: clearFilter ? null : (selectedFilter ?? this.selectedFilter),
    );
  }
}