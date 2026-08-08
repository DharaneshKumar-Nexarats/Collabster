import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'jobs_screen.dart';
import 'booked_sessions_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0; // 0 = All, 1 = Jobs, 2 = Interviews, 3 = System & Promos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filter Chips tab bar layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterTab(0, 'All'),
                    const SizedBox(width: 20),
                    _buildFilterTab(1, 'Jobs'),
                    const SizedBox(width: 20),
                    _buildFilterTab(2, 'Interviews'),
                    const SizedBox(width: 20),
                    _buildFilterTab(3, 'System & Promos'),
                  ],
                ),
              ),
            ),
            const Divider(height: 24, thickness: 1, color: Color(0xFFF3F4F6)),

            // Notifications List
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Item 1: Limited Time Offer (System & Promos = 3)
                      if (_selectedFilter == 0 || _selectedFilter == 3) ...[
                        _buildNotificationCard(
                          accentColor: const Color(0xFF0284C7),
                          icon: Icons.local_offer_outlined,
                          iconColor: const Color(0xFF0284C7),
                          iconBg: const Color(0xFFF0F9FF),
                          title: 'Limited Time Offer: 50% Off Pro',
                          time: 'Just now',
                          desc: 'Upgrade to ResuAI Pro for just \$9.99/mo. Unlock unlimited mock interviews and advanced resume optimization.',
                          primaryBtnText: 'Upgrade Now',
                          secondaryBtnText: 'Dismiss',
                          primaryBtnColor: const Color(0xFF0284C7),
                          onPrimaryTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening upgrade page...')),
                            );
                          },
                          onSecondaryTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notification dismissed')),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Item 2: Interview Confirmed! (Interviews = 2)
                      if (_selectedFilter == 0 || _selectedFilter == 2) ...[
                        _buildNotificationCard(
                          accentColor: const Color(0xFF0284C7),
                          icon: Icons.calendar_today_outlined,
                          iconColor: const Color(0xFF0284C7),
                          iconBg: const Color(0xFFE0F2FE),
                          title: 'Interview Confirmed!',
                          time: '2h ago',
                          desc: 'Google scheduled your technical round for Monday, Oct 19 at 10:00 AM.',
                          primaryBtnText: 'Join Lobby',
                          secondaryBtnText: 'View Schedule',
                          primaryBtnColor: const Color(0xFF0284C7),
                          onPrimaryTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const BookedSessionsScreen()));
                          },
                          onSecondaryTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const BookedSessionsScreen()));
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Item 3: 98% Match Found (Jobs = 1)
                      if (_selectedFilter == 0 || _selectedFilter == 1) ...[
                        _buildNotificationCard(
                          accentColor: const Color(0xFF10B981),
                          icon: Icons.auto_awesome_outlined,
                          iconColor: const Color(0xFF10B981),
                          iconBg: const Color(0xFFE6FBF3),
                          title: '98% Match Found',
                          time: 'Yesterday',
                          desc: 'Airbnb just posted a Remote React Developer role matching your exact skills stack.',
                          primaryBtnText: 'Quick Apply',
                          secondaryBtnText: 'Dismiss',
                          primaryBtnColor: const Color(0xFF10B981),
                          onPrimaryTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                          },
                          onSecondaryTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notification dismissed')),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Item 4: New message from David Chen (Interviews = 2)
                      if (_selectedFilter == 0 || _selectedFilter == 2) ...[
                        _buildNotificationCard(
                          accentColor: const Color(0xFF0284C7),
                          icon: Icons.chat_bubble_outline_rounded,
                          iconColor: const Color(0xFF0284C7),
                          iconBg: const Color(0xFFE0F2FE),
                          title: 'New message from David Chen (Meta)',
                          time: '5h ago',
                          desc: '"Hi Alex, great performance in our mock! I\'ve uploaded your full feedback sheet."',
                          primaryBtnText: 'Reply',
                          secondaryBtnText: 'Open Chat',
                          primaryBtnColor: const Color(0xFF0284C7),
                          onPrimaryTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening chat...')),
                            );
                          },
                          onSecondaryTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening chat...')),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Item 5: Saved Job Closing Soon (Jobs = 1)
                      if (_selectedFilter == 0 || _selectedFilter == 1) ...[
                        _buildNotificationCard(
                          accentColor: const Color(0xFFF59E0B),
                          icon: Icons.hourglass_empty_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          iconBg: const Color(0xFFFFEDD5),
                          title: 'Saved Job Closing Soon',
                          time: 'URGENT',
                          timeColor: const Color(0xFFEF4444),
                          desc: 'The Backend Engineer role you saved at Figma stops accepting responses in 4 hours.',
                          primaryBtnText: 'Apply Now',
                          primaryBtnColor: const Color(0xFFF59E0B),
                          onPrimaryTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Item 6: Application Status Update (Jobs = 1)
                      if (_selectedFilter == 0 || _selectedFilter == 1) ...[
                        _buildNotificationCard(
                          accentColor: Colors.grey.shade400,
                          icon: Icons.business_center_outlined,
                          iconColor: Colors.grey.shade600,
                          iconBg: const Color(0xFFF1F5F9),
                          title: 'Application Status Update',
                          time: '2 days ago',
                          desc: 'Stripe has closed the application for Frontend Engineer. Thank you for applying.',
                          secondaryBtnText: 'View Similar Jobs',
                          onSecondaryTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(int index, String label) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? const Color(0xFF0284C7) : Colors.grey.shade500,
            ),
          ),
          if (selected) ...[
            const SizedBox(height: 6),
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required Color accentColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String time,
    Color? timeColor,
    required String desc,
    String? primaryBtnText,
    String? secondaryBtnText,
    Color? primaryBtnColor,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSecondaryTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
          top: BorderSide(color: Colors.grey.shade100, width: 1),
          right: BorderSide(color: Colors.grey.shade100, width: 1),
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: timeColor ?? Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons
          if (primaryBtnText != null || secondaryBtnText != null)
            Row(
              children: [
                const SizedBox(width: 38), // Align button start with the title text
                if (primaryBtnText != null) ...[
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onPrimaryTap ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBtnColor ?? const Color(0xFF0284C7),
                        elevation: 0,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        primaryBtnText,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (secondaryBtnText != null)
                  TextButton(
                    onPressed: onSecondaryTap ?? () {},
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      secondaryBtnText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
