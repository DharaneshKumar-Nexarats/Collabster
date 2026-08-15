import 'package:flutter/material.dart';
import '../../../community/view/screens/posts_list_screen.dart';
import '../../../community/view/screens/communities_list_screen.dart';
import '../../../event/view/screens/event_home_screen.dart';
import 'jobs_screen.dart';
import 'booked_sessions_screen.dart';
import 'saved_jobs_screen.dart';

enum NotificationCategory { all, posts, events, communities, jobs, interviews }

class NotificationItem {
  final String id;
  final NotificationCategory category;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String actionText;
  final Widget Function(BuildContext) destinationScreenBuilder;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.actionText,
    required this.destinationScreenBuilder,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: '1',
        category: NotificationCategory.posts,
        title: 'New Post in Flutter Developers',
        description: 'Priya Sharma posted: "Just shipped a new feature using Flutter and Riverpod!"',
        time: 'Just now',
        icon: Icons.article_outlined,
        iconColor: const Color(0xFFEA580C),
        iconBg: const Color(0xFFFFF7ED),
        actionText: 'View Post',
        destinationScreenBuilder: (_) => const PostsListScreen(),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        category: NotificationCategory.events,
        title: 'Upcoming Event: Tech Startup Meetup',
        description: 'Tech Startup Meetup starts tomorrow in Bangalore. 120 attendees confirmed.',
        time: '1h ago',
        icon: Icons.event_outlined,
        iconColor: const Color(0xFF059669),
        iconBg: const Color(0xFFECFDF5),
        actionText: 'View Event',
        destinationScreenBuilder: (_) => const EventsListScreen(),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        category: NotificationCategory.communities,
        title: 'Community Activity Update',
        description: '86 members are active today in Flutter Developers. Join the ongoing discussions!',
        time: '3h ago',
        icon: Icons.people_outline_rounded,
        iconColor: const Color(0xFF2563EB),
        iconBg: const Color(0xFFEFF6FF),
        actionText: 'Explore Community',
        destinationScreenBuilder: (_) => const CommunitiesListScreen(),
        isRead: false,
      ),
      NotificationItem(
        id: '4',
        category: NotificationCategory.jobs,
        title: '98% Job Match Found',
        description: 'Notion is hiring a Remote React & Flutter Developer matching your exact skill set.',
        time: '5h ago',
        icon: Icons.work_outline_rounded,
        iconColor: const Color(0xFFD97706),
        iconBg: const Color(0xFFFFFBEB),
        actionText: 'View Job',
        destinationScreenBuilder: (_) => const JobsScreen(),
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        category: NotificationCategory.interviews,
        title: 'Interview Confirmed: Tech Round',
        description: 'Google scheduled your technical interview round for Monday, Oct 19 at 10:00 AM.',
        time: 'Yesterday',
        icon: Icons.calendar_today_outlined,
        iconColor: const Color(0xFF7C3AED),
        iconBg: const Color(0xFFF5F3FF),
        actionText: 'View Schedule',
        destinationScreenBuilder: (_) => const BookedSessionsScreen(),
        isRead: true,
      ),
      NotificationItem(
        id: '6',
        category: NotificationCategory.jobs,
        title: 'Saved Job Closing Soon',
        description: 'The Senior Product Designer role at Stripe stops accepting applications soon.',
        time: '2d ago',
        icon: Icons.bookmark_outline_rounded,
        iconColor: const Color(0xFFE11D48),
        iconBg: const Color(0xFFFFF1F2),
        actionText: 'View Saved Job',
        destinationScreenBuilder: (ctx) => SavedJobsScreen(onBack: () => Navigator.pop(ctx)),
        isRead: true,
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get _filteredNotifications {
    if (_selectedCategory == NotificationCategory.all) {
      return _notifications;
    }
    return _notifications.where((n) => n.category == _selectedCategory).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item.isRead = true;
      }
    });
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E293B)),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications?',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _notifications.clear();
              });
            },
            child: const Text('Clear All', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _openNotification(NotificationItem item) {
    setState(() {
      item.isRead = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: item.destinationScreenBuilder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark read',
                style: TextStyle(
                  color: Color(0xFFEA580C),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF64748B), size: 22),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterTab(NotificationCategory.all, 'All'),
                  const SizedBox(width: 8),
                  _buildFilterTab(NotificationCategory.posts, 'Posts'),
                  const SizedBox(width: 8),
                  _buildFilterTab(NotificationCategory.events, 'Events'),
                  const SizedBox(width: 8),
                  _buildFilterTab(NotificationCategory.communities, 'Communities'),
                  const SizedBox(width: 8),
                  _buildFilterTab(NotificationCategory.jobs, 'Jobs'),
                  const SizedBox(width: 8),
                  _buildFilterTab(NotificationCategory.interviews, 'Interviews'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _NotificationCard(
                        item: item,
                        onTap: () => _openNotification(item),
                        onDismiss: () {
                          setState(() {
                            _notifications.removeWhere((n) => n.id == item.id);
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(NotificationCategory category, String label) {
    final selected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEA580C).withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFFEA580C) : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? const Color(0xFFEA580C) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEA580C).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 40,
              color: Color(0xFFEA580C),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You\'re all caught up!\nNew updates will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.item,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead ? Colors.white : item.iconBg.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead ? const Color(0xFFF1F5F9) : item.iconColor.withValues(alpha: 0.3),
              width: item.isRead ? 1.0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: item.isRead ? FontWeight.w700 : FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: item.iconColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Action Button & Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: item.iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.actionText,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: item.iconColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 14, color: item.iconColor),
                            ],
                          ),
                        ),
                        Text(
                          item.time,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
