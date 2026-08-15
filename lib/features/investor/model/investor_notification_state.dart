import 'notification_model.dart';

class InvestorNotificationState {
  const InvestorNotificationState({
    this.notifications = const [],
    this.selectedFilter,
  });

  final List<InvestorNotification> notifications;
  final InvestorNotificationType? selectedFilter;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<InvestorNotification> get filteredNotifications {
    if (selectedFilter == null) return notifications;
    return notifications.where((n) => n.type == selectedFilter).toList();
  }

  InvestorNotificationState copyWith({
    List<InvestorNotification>? notifications,
    InvestorNotificationType? selectedFilter,
    bool clearFilter = false,
  }) {
    return InvestorNotificationState(
      notifications: notifications ?? this.notifications,
      selectedFilter: clearFilter ? null : (selectedFilter ?? this.selectedFilter),
    );
  }
}