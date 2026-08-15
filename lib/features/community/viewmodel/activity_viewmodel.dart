import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/activity_model.dart';
import 'activity_state.dart';

class ActivityViewModel extends StateNotifier<ActivityState> {
  ActivityViewModel() : super(ActivityState(activities: _seed));

  static final List<ActivityItem> _seed = [
    ActivityItem(
      id: 'act_seed_1',
      type: ActivityType.memberJoined,
      title: 'New member joined',
      subtitle: 'Sarah Lee joined Flutter Developers',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ActivityItem(
      id: 'act_seed_2',
      type: ActivityType.postCreated,
      title: 'New post published',
      subtitle: 'Best practices for Flutter state management',
      timestamp: _t2,
    ),
    ActivityItem(
      id: 'act_seed_3',
      type: ActivityType.postLiked,
      title: 'Your post got 20 likes',
      subtitle: 'Design Systems best practices',
      timestamp: _t3,
    ),
    ActivityItem(
      id: 'act_seed_4',
      type: ActivityType.eventCreated,
      title: 'Upcoming event',
      subtitle: 'Flutter Forward Watch Party - Tomorrow',
      timestamp: _t4,
    ),
    ActivityItem(
      id: 'act_seed_5',
      type: ActivityType.commentAdded,
      title: 'New comment on your post',
      subtitle: 'Rahul Verma commented on Flutter state management',
      timestamp: _t5,
    ),
    ActivityItem(
      id: 'act_seed_6',
      type: ActivityType.communityCreated,
      title: 'New community created',
      subtitle: 'AI Engineers community is now live',
      timestamp: _t6,
    ),
    ActivityItem(
      id: 'act_seed_7',
      type: ActivityType.replyAdded,
      title: 'Reply to your discussion',
      subtitle: 'Ananya replied on Design Systems best practices',
      timestamp: _t7,
    ),
  ];

  static final DateTime _t2 = DateTime.now().subtract(const Duration(hours: 3));
  static final DateTime _t3 = DateTime.now().subtract(const Duration(hours: 5));
  static final DateTime _t4 = DateTime.now().subtract(const Duration(hours: 8));
  static final DateTime _t5 = DateTime.now().subtract(const Duration(days: 1));
  static final DateTime _t6 = DateTime.now().subtract(const Duration(days: 2));
  static final DateTime _t7 = DateTime.now().subtract(const Duration(days: 3));

  void addActivity({
    required ActivityType type,
    required String title,
    required String subtitle,
  }) {
    final item = ActivityItem(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      title: title,
      subtitle: subtitle,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      activities: [item, ...state.activities],
      unreadCount: state.unreadCount + 1,
    );
  }

  void markActivitiesAsRead() {
    state = state.copyWith(unreadCount: 0);
  }
}
