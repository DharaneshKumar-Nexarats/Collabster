import 'package:flutter/material.dart';

import '../../model/notification_model.dart';
import '../../viewmodel/notifications_viewmodel.dart';
import '../../viewmodel/team_viewmodel.dart';
import '../widgets/startup_color_helper.dart';
import 'messages_inbox_screen.dart';
import 'startup_milestones_screen.dart';
import 'investor_pipeline_screen.dart';
import 'startup_documents_screen.dart';
import 'team_command_screen.dart';
import 'startup_requests_screen.dart';
import 'startup_events_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final String startupName;

  const NotificationsScreen({
    super.key,
    required this.startupName,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NotificationsViewModel();
    _viewModel.loadNotifications(startupName: widget.startupName);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              _buildFilterChips(),
              if (_viewModel.filteredNotifications.isEmpty)
                _buildEmptyState()
              else
                _buildNotificationsList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      backgroundColor: const Color(0xFF5B21B6),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Notifications',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (_viewModel.hasUnread)
          TextButton(
            onPressed: () {
              setState(() {
                _viewModel.markAllAsRead();
              });
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (_viewModel.notifications.isNotEmpty)
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white70,
              size: 22,
            ),
            onPressed: _showClearAllDialog,
          ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFFF6F3FF),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_viewModel.unreadCount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${_viewModel.unreadCount} unread notification${_viewModel.unreadCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('All', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('Connections', NotificationType.connection),
                  const SizedBox(width: 8),
                  _buildFilterChip('Messages', NotificationType.message),
                  const SizedBox(width: 8),
                  _buildFilterChip('Milestones', NotificationType.milestone),
                  const SizedBox(width: 8),
                  _buildFilterChip('Funding', NotificationType.funding),
                  const SizedBox(width: 8),
                  _buildFilterChip('Team', NotificationType.team),
                  const SizedBox(width: 8),
                  _buildFilterChip('Documents', NotificationType.document),
                  const SizedBox(width: 8),
                  _buildFilterChip('System', NotificationType.system),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, NotificationType? type) {
    final isSelected = _viewModel.selectedFilter == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewModel.setFilter(type);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B21B6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5B21B6)
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF5B21B6).withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: Color(0xFFD1D5DB),
            ),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You\'ll see notifications here when\nthere\'s activity related to your startup.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final notification = _viewModel.filteredNotifications[index];
            final isFirst = index == 0;
            final isLast = index == _viewModel.filteredNotifications.length - 1;

            return _buildNotificationTile(
              notification: notification,
              isFirst: isFirst,
              isLast: isLast,
            );
          },
          childCount: _viewModel.filteredNotifications.length,
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required AppNotification notification,
    required bool isFirst,
    required bool isLast,
  }) {
    final color = StartupColorHelper.fromKey(notification.colorKey);
    final icon = StartupColorHelper.iconFromKey(notification.iconKey);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() {
          _viewModel.deleteNotification(notification.id);
        });
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(
          bottom: isLast ? 0 : 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(16) : Radius.zero,
            bottom: isLast ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _viewModel.markAsRead(notification.id);
          });
          _handleNotificationTap(notification);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.vertical(
              top: isFirst ? const Radius.circular(16) : Radius.zero,
              bottom: isLast ? const Radius.circular(16) : Radius.zero,
            ),
            border: Border.all(
              color: notification.isRead
                  ? const Color(0xFFE5E7EB)
                  : const Color(0xFFDDD6FE),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(color, icon),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNotificationContent(notification),
              ),
              _buildNotificationTime(notification),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(Color color, IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildNotificationContent(AppNotification notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
                  color: const Color(0xFF12233D),
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          notification.subtitle,
          style: TextStyle(
            fontSize: 13,
            fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w500,
            color: const Color(0xFF6B7280),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (notification.body != null && notification.body!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              notification.body!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationTime(AppNotification notification) {
    return Text(
      _formatTimeAgo(notification.createdAt),
      style: const TextStyle(
        fontSize: 11,
        color: Color(0xFF9CA3AF),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  void _handleNotificationTap(AppNotification notification) {
    setState(() {
      _viewModel.markAsRead(notification.id);
    });

    switch (notification.type) {
      case NotificationType.connection:
        _navigateToRequests();
        break;
      case NotificationType.message:
        _navigateToMessages();
        break;
      case NotificationType.milestone:
        _navigateToMilestones();
        break;
      case NotificationType.funding:
        _navigateToInvestors();
        break;
      case NotificationType.team:
        _navigateToTeam();
        break;
      case NotificationType.document:
        _navigateToDocuments();
        break;
      case NotificationType.system:
        _navigateToEvents();
        break;
    }
  }

  void _navigateToMessages() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessagesInboxScreen(
          viewModel: TeamViewModel(),
          startupName: widget.startupName,
        ),
      ),
    );
  }

  void _navigateToMilestones() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StartupMilestonesScreen(),
      ),
    );
  }

  void _navigateToInvestors() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const InvestorPipelineScreen(),
      ),
    );
  }

  void _navigateToDocuments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StartupDocumentsScreen(),
      ),
    );
  }

  void _navigateToTeam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeamCommandScreen(
          startupName: widget.startupName,
        ),
      ),
    );
  }

  void _navigateToRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StartupRequestsScreen(
          startupName: widget.startupName,
        ),
      ),
    );
  }

  void _navigateToEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StartupEventsScreen(
          startupName: widget.startupName,
        ),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF12233D),
          ),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _viewModel.clearAll();
              });
            },
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
