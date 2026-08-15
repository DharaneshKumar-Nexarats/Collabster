import '../model/activity_model.dart';

class ActivityState {
  const ActivityState({this.activities = const [], this.unreadCount = 0});

  final List<ActivityItem> activities;
  final int unreadCount;

  ActivityState copyWith({List<ActivityItem>? activities, int? unreadCount}) {
    return ActivityState(
      activities: activities ?? this.activities,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
