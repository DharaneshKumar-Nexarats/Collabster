import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/role_switcher_sheet.dart';
import '../../../core/di/providers.dart';
import '../../auth/view/screens/profile_screen.dart';
import '../../auth/view/sign_in_screen.dart';
import '../../career/view/screens/jobs_screen.dart';
import '../../career/view/screens/freelance_screen.dart';
import '../../career/view/screens/resume_screen.dart';
import '../../career/view/screens/notifications_screen.dart';
import '../../career/view/screens/saved_jobs_screen.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  int _selectedIndex = 0;

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _onNavTap(int index) {
    if (index == 2) {
      _showCreateSheet();
      return;
    }
    if (index == 4) {
      _showProfileSheet();
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(999)),
                      child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  _buildSheetAction(Icons.search_rounded, 'Explore', const Color(0xFFEA580C), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                  }),
                  _buildSheetAction(Icons.work_outline_rounded, 'Jobs', const Color(0xFFF97316), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                  }),
                  _buildSheetAction(Icons.laptop_mac_outlined, 'Freelance', const Color(0xFFFB923C), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FreelanceScreen()));
                  }),
                  _buildSheetAction(Icons.description_outlined, 'Resume', const Color(0xFFC2410C), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResumeScreen()));
                  }),
                  _buildSheetAction(Icons.bookmark_outline_rounded, 'Saved', const Color(0xFFEA580C), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SavedJobsScreen(onBack: () => Navigator.pop(context))));
                  }),
                  _buildSheetAction(Icons.notifications_outlined, 'Alerts', const Color(0xFFF97316), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF374151), height: 1.25),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      _buildExplorePage(),
      const SizedBox.shrink(),
      _buildSavedPage(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: pages[_selectedIndex],
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  // ── Home tab ──────────────────────────────────────────────────────────
  Widget _buildHomeContent() {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Explorer';
    final greetingName = userName.split(RegExp(r'\s+')).first;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEA580C),
                  Color(0xFFF97316),
                  Color(0xFFEA580C),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(Icons.diamond_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CollabSphere',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Your all-in-one workspace',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openNotifications(),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: Color(0xFFFBBF24), shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$_timeBasedGreeting, $greetingName',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Here's what's happening across your network today.",
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13.5),
                    ),
                    const SizedBox(height: 18),
                    // Stats row
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _headerStat(Icons.people_outline_rounded, '12', 'Connections'),
                          _headerDivider(),
                          _headerStat(Icons.work_outline_rounded, '5', 'Opportunities'),
                          _headerDivider(),
                          _headerStat(Icons.auto_stories_outlined, '8', 'Learning'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionHeader('Quick Actions', null),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(),
              const SizedBox(height: 24),

              _buildSectionHeader('Featured Opportunities', 'View all', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
              }),
              const SizedBox(height: 4),
              Text('Curated picks based on your interests', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 14),
              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _FeatureCard(
                      title: 'Product Designer',
                      company: 'Notion',
                      location: 'Remote',
                      tags: ['Design', 'Figma'],
                      status: 'New',
                      accent: Color(0xFFEA580C),
                      statusBg: Color(0xFFFFF7ED),
                      statusFg: Color(0xFFC2410C),
                    ),
                    SizedBox(width: 12),
                    _FeatureCard(
                      title: 'Growth Marketer',
                      company: 'Vercel',
                      location: 'Hybrid',
                      tags: ['Marketing', 'Analytics'],
                      status: 'Hot',
                      accent: Color(0xFFF97316),
                      statusBg: Color(0xFFFFF7ED),
                      statusFg: Color(0xFFC2410C),
                    ),
                    SizedBox(width: 12),
                    _FeatureCard(
                      title: 'DevOps Engineer',
                      company: 'Stripe',
                      location: 'Remote',
                      tags: ['AWS', 'Kubernetes'],
                      status: 'New',
                      accent: Color(0xFFFB923C),
                      statusBg: Color(0xFFFFF7ED),
                      statusFg: Color(0xFFC2410C),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              _buildSectionHeader('Trending Topics', null),
              const SizedBox(height: 14),
              _buildTrendingTopics(),
              const SizedBox(height: 26),

              _buildSectionHeader('Recent Activity', 'View all'),
              const SizedBox(height: 14),
              _buildActivityCard(
                icon: Icons.person_add_outlined,
                iconBg: const Color(0xFFFFF7ED),
                iconFg: const Color(0xFFEA580C),
                title: 'New connection request',
                subtitle: 'Sarah Chen wants to connect with you',
                time: '2h ago',
              ),
              const SizedBox(height: 10),
              _buildActivityCard(
                icon: Icons.work_outline_rounded,
                iconBg: const Color(0xFFFFF7ED),
                iconFg: const Color(0xFFF97316),
                title: 'Job match found',
                subtitle: 'Senior Flutter Developer at Shopify',
                time: '5h ago',
              ),
              const SizedBox(height: 10),
              _buildActivityCard(
                icon: Icons.auto_stories_outlined,
                iconBg: const Color(0xFFFFF7ED),
                iconFg: const Color(0xFFFB923C),
                title: 'Course completed',
                subtitle: 'Advanced React Patterns - 92% score',
                time: '1d ago',
              ),
              const SizedBox(height: 10),
              _buildActivityCard(
                icon: Icons.star_outline_rounded,
                iconBg: const Color(0xFFFFF7ED),
                iconFg: const Color(0xFFC2410C),
                title: 'Profile view spike',
                subtitle: 'Your profile was viewed 24 times this week',
                time: '2d ago',
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Explore tab ──────────────────────────────────────────────────────────
  Widget _buildExplorePage() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => setState(() => _selectedIndex = 0),
        ),
        title: const Text('Explore', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildExploreCard(Icons.work_outline_rounded, 'Jobs', 'Browse opportunities from top companies', const Color(0xFFEA580C)),
          const SizedBox(height: 12),
          _buildExploreCard(Icons.laptop_mac_outlined, 'Freelance', 'Find freelance projects and gigs', const Color(0xFFF97316)),
          const SizedBox(height: 12),
          _buildExploreCard(Icons.school_outlined, 'Learning', 'Upskill with courses and tutorials', const Color(0xFFFB923C)),
          const SizedBox(height: 12),
          _buildExploreCard(Icons.people_outline_rounded, 'Network', 'Connect with professionals', const Color(0xFFC2410C)),
        ],
      ),
    );
  }

  Widget _buildExploreCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
        ],
      ),
    );
  }

  // ── Saved tab ──────────────────────────────────────────────────────────
  Widget _buildSavedPage() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => setState(() => _selectedIndex = 0),
        ),
        title: const Text('Saved', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No saved items yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
            const SizedBox(height: 6),
            Text('Items you save will appear here', style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  // ── Quick Actions ──────────────────────────────────────────────────
  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(Icons.search_rounded, 'Explore', const Color(0xFFEA580C), () {
        setState(() => _selectedIndex = 1);
      }),
      _QuickAction(Icons.work_outline_rounded, 'Jobs', const Color(0xFFF97316), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
      }),
      _QuickAction(Icons.laptop_mac_outlined, 'Freelance', const Color(0xFFFB923C), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FreelanceScreen()));
      }),
      _QuickAction(Icons.description_outlined, 'Resume', const Color(0xFFC2410C), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ResumeScreen()));
      }),
      _QuickAction(Icons.bookmark_outline_rounded, 'Saved', const Color(0xFFEA580C), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SavedJobsScreen(onBack: () => Navigator.pop(context))));
      }),
      _QuickAction(Icons.notifications_outlined, 'Alerts', const Color(0xFFF97316), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
      }),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildQuickActionItem(actions[0]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[1]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[2]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[3]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[4]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[5]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(_QuickAction action) {
    return Expanded(
      child: GestureDetector(
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: action.color.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: action.color, size: 19),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  action.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Trending Topics ──────────────────────────────────────────────────
  Widget _buildTrendingTopics() {
    final topics = [
      _TrendingTopic('AI & Machine Learning', '142 posts', const Color(0xFFEA580C)),
      _TrendingTopic('Remote Work', '98 posts', const Color(0xFFF97316)),
      _TrendingTopic('Startup Funding', '76 posts', const Color(0xFFFB923C)),
      _TrendingTopic('Flutter Development', '64 posts', const Color(0xFFC2410C)),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Column(
        children: topics.asMap().entries.map((entry) {
          final i = entry.key;
          final topic = entry.value;
          return Column(
            children: [
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Divider(height: 1, color: Colors.grey.shade100),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: topic.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.trending_up_rounded, color: topic.color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(topic.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                          Text(topic.count, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 14),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Activity Card ──────────────────────────────────────────────────
  Widget _buildActivityCard({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconFg, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String? cta, {VoidCallback? onCtaTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.2)),
        if (cta != null)
          GestureDetector(
            onTap: onCtaTap ?? () {},
            child: Text(cta, style: const TextStyle(fontSize: 13, color: Color(0xFFEA580C), fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _headerStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _headerDivider() {
    return Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.2));
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  // ── Profile bottom sheet ──────────────────────────────────────────
  void _showProfileSheet() {
    final session = ref.read(authViewModelProvider).session;
    final userName = session?.fullName ?? 'Member';
    final email = session?.email ?? '';
    final roleLabel = session?.activeUserRole.label ?? 'Member';
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();

    String getInitials(String name) {
      final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      if (parts.isNotEmpty) return parts[0][0].toUpperCase();
      return '?';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
                  const SizedBox(height: 14),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFFFF7ED),
                    backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                    child: hasPhoto ? null : Text(getInitials(userName), style: const TextStyle(color: Color(0xFFEA580C), fontSize: 24, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  Text(userName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  if (email.isNotEmpty) ...[const SizedBox(height: 2), Text(email, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500))],
                  const SizedBox(height: 2),
                  Text(roleLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                  const SizedBox(height: 14),
                  _sheetAction(Icons.person_outline_rounded, 'View Profile', const Color(0xFFEA580C), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  }),
                  const SizedBox(height: 8),
                  _sheetAction(Icons.swap_horiz_rounded, 'Switch Role', const Color(0xFFEA580C), () {
                    Navigator.pop(ctx);
                    RoleSwitcherSheet.show(context);
                  }),
                  const SizedBox(height: 8),
                  _sheetAction(Icons.logout_rounded, 'Logout', const Color(0xFFEF4444), () async {
                    Navigator.pop(ctx);
                    await ref.read(authViewModelProvider.notifier).logout();
                    if (!mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
                  }),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF12233D))),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.color, this.onTap);
}

class _TrendingTopic {
  final String title;
  final String count;
  final Color color;
  const _TrendingTopic(this.title, this.count, this.color);
}

class _FeatureCard extends StatelessWidget {
  final String title, company, location, status;
  final List<String> tags;
  final Color accent, statusBg, statusFg;

  const _FeatureCard({required this.title, required this.company, required this.location, required this.status, required this.tags, required this.accent, required this.statusBg, required this.statusFg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.grid_view_rounded, color: accent, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusFg)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.25)),
          const SizedBox(height: 4),
          Text('$company • $location', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 10),
          Row(
            children: tags.take(2).map((t) {
              return Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                child: Text(t, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: accent)),
              );
            }).toList(),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C), minimumSize: const Size(0, 36), padding: EdgeInsets.zero, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Apply', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFED7AA)), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.bookmark_border_rounded, size: 17, color: Color(0xFFEA580C)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOTTOM NAVIGATION BAR
// ═══════════════════════════════════════════════════════════════════════════
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});
  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const double _navBarHeight = 64;
  static const double _fabSize = 56;
  static const double _navBarTop = 14;
  static const double _fabTop = -12;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalHeight = _navBarTop + _navBarHeight + bottomInset + 8;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: _navBarTop,
            left: 12,
            right: 12,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: CustomPaint(
                painter: _SeamlessNavPainter(fillColor: Colors.white, borderColor: const Color(0xFFE2E4EA), shadowColor: Colors.black.withValues(alpha: 0.08)),
                size: Size.infinite,
                child: SizedBox(
                  height: _navBarHeight,
                  child: Row(
                    children: [
                      _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                      _navItem(1, Icons.explore_outlined, Icons.explore_rounded, 'Explore'),
                      SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.bookmark_outline_rounded, Icons.bookmark_rounded, 'Saved'),
                      _navItem(4, Icons.person_outline, Icons.person, 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: _fabTop, left: 0, right: 0, child: Center(child: _addButton())),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    const selectedColor = Color(0xFFEA580C);
    const unselectedColor = Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, color: selected ? selectedColor : unselectedColor, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? selectedColor : unselectedColor)),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: _fabSize,
        height: _fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFF97316)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color(0xFFEA580C).withValues(alpha: 0.30), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _SeamlessNavPainter extends CustomPainter {
  const _SeamlessNavPainter({required this.fillColor, required this.borderColor, required this.shadowColor});
  final Color fillColor;
  final Color borderColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final h = size.height;
    final w = size.width;
    final centerX = w / 2;
    const cornerRadius = 28.0;
    const fabRadius = 28.0;
    const clearance = 5.0;
    const notchR = fabRadius + clearance;
    const notchW = notchR + 14;
    const bottomArc = 2.5;

    final path = Path()
      ..moveTo(cornerRadius, 0)
      ..lineTo(centerX - notchW, 0)
      ..cubicTo(centerX - notchW + 10, 0, centerX - notchR * 1.1, notchR * 0.06, centerX - notchR, notchR * 0.35)
      ..cubicTo(centerX - notchR * 0.92, notchR * 0.6, centerX - notchR * 0.75, notchR * 0.85, centerX - notchR * 0.5, notchR * 0.98)
      ..cubicTo(centerX - notchR * 0.28, notchR * 1.05, centerX - 14, notchR * 1.06, centerX, notchR * 1.06)
      ..cubicTo(centerX + 14, notchR * 1.06, centerX + notchR * 0.28, notchR * 1.05, centerX + notchR * 0.5, notchR * 0.98)
      ..cubicTo(centerX + notchR * 0.75, notchR * 0.85, centerX + notchR * 0.92, notchR * 0.6, centerX + notchR, notchR * 0.35)
      ..cubicTo(centerX + notchR * 1.1, notchR * 0.06, centerX + notchW - 10, 0, centerX + notchW, 0)
      ..lineTo(w - cornerRadius, 0)
      ..arcToPoint(Offset(w, cornerRadius), radius: const Radius.circular(cornerRadius))
      ..lineTo(w, h - cornerRadius)
      ..arcToPoint(Offset(w - cornerRadius, h), radius: const Radius.circular(cornerRadius))
      ..quadraticBezierTo(centerX, h - bottomArc, cornerRadius, h)
      ..arcToPoint(Offset(0, h - cornerRadius), radius: const Radius.circular(cornerRadius))
      ..lineTo(0, cornerRadius)
      ..arcToPoint(Offset(cornerRadius, 0), radius: const Radius.circular(cornerRadius))
      ..close();

    canvas.drawShadow(path, shadowColor, 24, true);
    canvas.drawShadow(path, shadowColor.withValues(alpha: 0.5), 6, true);
    canvas.drawPath(path, Paint()..style = PaintingStyle.fill..color = fillColor);
    canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0..color = borderColor);
  }

  @override
  bool shouldRepaint(covariant _SeamlessNavPainter oldDelegate) => oldDelegate.fillColor != fillColor || oldDelegate.borderColor != borderColor || oldDelegate.shadowColor != shadowColor;
}
