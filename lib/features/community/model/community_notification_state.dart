import 'notification_model.dart';

class CommunityNotificationState {
  const CommunityNotificationState({
    this.notifications = const [],
    this.selectedFilter,
  });

  final List<CommunityNotification> notifications;
  final CommunityNotificationType? selectedFilter;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<CommunityNotification> get filteredNotifications {
    if (selectedFilter == null) return notifications;
    return notifications.where((n) => n.type == selectedFilter).toList();
  }

  CommunityNotificationState copyWith({
    List<CommunityNotification>? notifications,
    CommunityNotificationType? selectedFilter,
    bool clearFilter = false,
  }) {
    return CommunityNotificationState(
      notifications: notifications ?? this.notifications,
      selectedFilter: clearFilter ? null : (selectedFilter ?? this.selectedFilter),
    );
  }
}