import 'notification_model.dart';

class CareerNotificationState {
  const CareerNotificationState({
    this.notifications = const [],
    this.selectedFilter,
  });

  final List<CareerNotification> notifications;
  final CareerNotificationType? selectedFilter;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<CareerNotification> get filteredNotifications {
    if (selectedFilter == null) return notifications;
    return notifications.where((n) => n.type == selectedFilter).toList();
  }

  CareerNotificationState copyWith({
    List<CareerNotification>? notifications,
    CareerNotificationType? selectedFilter,
    bool clearFilter = false,
  }) {
    return CareerNotificationState(
      notifications: notifications ?? this.notifications,
      selectedFilter: clearFilter ? null : (selectedFilter ?? this.selectedFilter),
    );
  }
}