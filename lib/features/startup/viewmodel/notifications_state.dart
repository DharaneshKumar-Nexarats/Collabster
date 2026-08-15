import '../model/notification_model.dart';

class NotificationsState {
  const NotificationsState({
    this.notifications = const [],
    this.selectedFilter,
  });

  final List<AppNotification> notifications;
  final NotificationType? selectedFilter;

  List<AppNotification> get filteredNotifications {
    if (selectedFilter == null) {
      return List.unmodifiable(notifications);
    }
    return notifications.where((n) => n.type == selectedFilter).toList();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    NotificationType? selectedFilter,
    bool clearFilter = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      selectedFilter: clearFilter ? null : (selectedFilter ?? this.selectedFilter),
    );
  }
}
