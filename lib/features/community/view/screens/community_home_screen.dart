import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../auth/view/screens/profile_screen.dart';
import '../../../auth/view/sign_in_screen.dart';
import '../../../career/view/screens/notifications_screen.dart';
import '../../model/community_model.dart';
import 'create_post_screen.dart';

class CommunityHomeScreen extends ConsumerStatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  ConsumerState<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends ConsumerState<CommunityHomeScreen> {
  int _selectedBottomNavIndex = 0; // 0 represents Home tab
  String _selectedCategoryId = 'all';
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Categories list matching screenshot
  final List<CommunityCategory> _categories = const [
    CommunityCategory(id: 'all', label: 'All', icon: Icons.grid_view_rounded),
    CommunityCategory(id: 'tech', label: 'Tech', icon: Icons.code_rounded),
    CommunityCategory(id: 'startup', label: 'Startup', icon: Icons.rocket_launch_outlined),
    CommunityCategory(id: 'design', label: 'Design', icon: Icons.edit_outlined),
    CommunityCategory(id: 'ai_ml', label: 'AI / ML', icon: Icons.psychology_outlined),
  ];

  // "What's Happening" mock items matching screenshot
  final List<WhatsHappeningItem> _whatsHappeningList = const [
    WhatsHappeningItem(
      id: 'wh_1',
      title: 'Flutter Developers',
      subtitle: '12 new discussions • 36 new replies',
      icon: Icons.chat_bubble_rounded,
      iconColor: Color(0xFFEA580C),
      iconBgColor: Color(0xFFFFF7ED),
    ),
    WhatsHappeningItem(
      id: 'wh_2',
      title: 'Startup Founders',
      subtitle: '5 new discussions • 2 upcoming events',
      icon: Icons.calendar_today_rounded,
      iconColor: Color(0xFFEA580C),
      iconBgColor: Color(0xFFFFEDD5),
    ),
    WhatsHappeningItem(
      id: 'wh_3',
      title: 'UI/UX Designers',
      subtitle: '8 new posts • 14 new replies',
      icon: Icons.palette_outlined,
      iconColor: Color(0xFF0284C7),
      iconBgColor: Color(0xFFE0F2FE),
    ),
  ];

  // "My Communities" mock items matching screenshot
  late List<MyCommunityItem> _myCommunities;

  // "Recommended for you" mock items matching screenshot
  late List<RecommendedCommunityItem> _recommendedCommunities;

  @override
  void initState() {
    super.initState();
    _myCommunities = [
      MyCommunityItem(
        id: 'mc_1',
        title: 'Flutter Developers',
        memberCount: '2.4K Members',
        activeTodayCount: '86 active today',
        avatarUrls: [
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        ],
        overflowCount: 32,
        gradientColors: const [Color(0xFFEA580C), Color(0xFFF97316)],
        logoIcon: Icons.widgets_rounded,
        categoryId: 'tech',
      ),
      MyCommunityItem(
        id: 'mc_2',
        title: 'Startup Founders',
        memberCount: '1.8K Members',
        activeTodayCount: '42 active today',
        avatarUrls: [
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150',
        ],
        overflowCount: 18,
        gradientColors: const [Color(0xFFF97316), Color(0xFFEA580C)],
        logoIcon: Icons.rocket_launch_rounded,
        categoryId: 'startup',
      ),
    ];

    _recommendedCommunities = [
      RecommendedCommunityItem(
        id: 'rc_1',
        title: 'AI Engineers',
        memberCount: '3.8K Members',
        tag: 'AI / ML',
        categoryId: 'ai_ml',
        icon: Icons.psychology_rounded,
        iconBgColor: const Color(0xFF1E293B),
        iconColor: Colors.white,
      ),
      RecommendedCommunityItem(
        id: 'rc_2',
        title: 'Product Managers',
        memberCount: '2.6K Members',
        tag: 'Product',
        categoryId: 'startup',
        icon: Icons.work_rounded,
        iconBgColor: const Color(0xFF0D9488),
        iconColor: Colors.white,
      ),
      RecommendedCommunityItem(
        id: 'rc_3',
        title: 'Growth Hackers',
        memberCount: '1.9K Members',
        tag: 'Marketing',
        categoryId: 'startup',
        icon: Icons.trending_up_rounded,
        iconBgColor: const Color(0xFFEA580C),
        iconColor: Colors.white,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (index == 2) {
      _openCreatePostScreen();
      return;
    }
    if (index == 4) {
      _showProfileSheet();
      return;
    }
    setState(() {
      _selectedBottomNavIndex = index;
    });
  }

  void _openCreatePostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
  }

  void _openNotificationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Member';

    final pages = [
      _buildHomeTab(userName),
      _buildCommunityTab(context, userName, session?.email ?? ''),
      _buildHomeTab(userName),
      _buildMessagesTab(),
      _buildHomeTab(userName),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: _buildDrawer(context, userName, session?.email ?? ''),
      body: pages[_selectedBottomNavIndex],
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // HOME TAB - Dashboard
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildHomeTab(String userName) {
    final greetingName = userName.split(RegExp(r'\s+')).first;

    String timeGreeting() {
      final hour = DateTime.now().hour;
      if (hour >= 5 && hour < 12) return 'Good Morning';
      if (hour >= 12 && hour < 17) return 'Good Afternoon';
      return 'Good Evening';
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEA580C), Color(0xFFF97316), Color(0xFFEA580C)],
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
                            gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: const Icon(Icons.groups_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Community Hub', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                              Text('Connect, collaborate, grow', style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.5)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _openNotificationsScreen,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                            child: Stack(
                              children: [
                                const Center(child: Icon(Icons.notifications_outlined, color: Colors.white, size: 22)),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('${timeGreeting()}, $greetingName', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text("Here's what's happening in your communities today.", style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13.5)),
                    const SizedBox(height: 18),
                    // Stats row
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _homeStat(Icons.groups_rounded, '3', 'Communities'),
                          _homeDivider(),
                          _homeStat(Icons.article_outlined, '12', 'Posts'),
                          _homeDivider(),
                          _homeStat(Icons.chat_bubble_outline_rounded, '28', 'Replies'),
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
              // Quick Actions
              _buildSectionHeader(title: 'Quick Actions', onViewAll: () {}),
              const SizedBox(height: 12),
              _buildHomeQuickActions(),
              const SizedBox(height: 24),

              // Trending Posts
              _buildSectionHeader(title: 'Trending Posts', onViewAll: () {}),
              const SizedBox(height: 12),
              _buildTrendingPostCard(
                author: 'Priya Sharma',
                time: '2h ago',
                content: 'Just shipped a new feature using Flutter and Riverpod! The state management is so clean now.',
                likes: 42,
                comments: 8,
                tag: 'Flutter',
                tagColor: const Color(0xFFEA580C),
              ),
              const SizedBox(height: 10),
              _buildTrendingPostCard(
                author: 'Alex Chen',
                time: '4h ago',
                content: 'Looking for a co-founder for an AI-powered health tech startup. DM if interested!',
                likes: 31,
                comments: 15,
                tag: 'Startup',
                tagColor: const Color(0xFFEA580C),
              ),
              const SizedBox(height: 24),

              // Recent Activity
              _buildSectionHeader(title: 'Recent Activity', onViewAll: () {}),
              const SizedBox(height: 12),
              _buildActivityItem(Icons.person_add_outlined, 'New member joined', 'Sarah Lee joined Flutter Developers', '1h ago', const Color(0xFF059669)),
              const SizedBox(height: 8),
              _buildActivityItem(Icons.thumb_up_outlined, 'Your post got 20 likes', 'Design Systems best practices', '3h ago', const Color(0xFFEA580C)),
              const SizedBox(height: 8),
              _buildActivityItem(Icons.event_outlined, 'Upcoming event', 'Flutter Forward Watch Party - Tomorrow', '5h ago', const Color(0xFF2563EB)),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _homeStat(IconData icon, String value, String label) {
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

  Widget _homeDivider() {
    return Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.2));
  }

  Widget _buildHomeQuickActions() {
    final actions = [
      _QuickAction(Icons.article_outlined, 'Create Post', const Color(0xFFEA580C), _openCreatePostScreen),
      _QuickAction(Icons.search_rounded, 'Discover', const Color(0xFF2563EB), () {}),
      _QuickAction(Icons.event_outlined, 'Events', const Color(0xFF059669), () {}),
      _QuickAction(Icons.bookmark_outline_rounded, 'Saved', const Color(0xFF7C3AED), () {}),
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

  Widget _buildTrendingPostCard({
    required String author,
    required String time,
    required String content,
    required int likes,
    required int comments,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: tagColor.withValues(alpha: 0.12),
                child: Text(author[0], style: TextStyle(color: tagColor, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                    Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                child: Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: tagColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text('$likes', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text('$comments', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.share_outlined, size: 18, color: Colors.grey.shade500),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle, String time, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
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

  // ══════════════════════════════════════════════════════════════════════
  // COMMUNITY TAB
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildCommunityTab(BuildContext context, String userName, String email) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Community',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), letterSpacing: -0.3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 96,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, index) {
                  final cat = _categories[index];
                  final isSelected = cat.id == _selectedCategoryId;
                  return _buildCategoryCard(cat, isSelected);
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(title: "What's Happening", onViewAll: () {}),
                const SizedBox(height: 12),
                _buildWhatsHappeningCard(),
                const SizedBox(height: 24),
                _buildSectionHeader(title: 'My Communities', onViewAll: () {}),
                const SizedBox(height: 12),
                _buildMyCommunitiesList(),
                const SizedBox(height: 24),
                _buildSectionHeader(title: 'Recommended for you', onViewAll: () {}),
                const SizedBox(height: 12),
                _buildRecommendedCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 64, color: Color(0xFF94A3B8)),
            SizedBox(height: 16),
            Text(
              'Messages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
            ),
            SizedBox(height: 8),
            Text(
              'Your direct messages will appear here',
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Input Bar ───────────────────────────────────────────────────
  Widget _buildSearchBar() {
    final hasText = _searchController.text.isNotEmpty;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Search communities, people, posts...',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (hasText)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF64748B),
                  size: 14,
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // ── Category Filter Card ───────────────────────────────────────────────
  Widget _buildCategoryCard(CommunityCategory cat, bool isSelected) {
    const selectedBorderColor = Color(0xFFEA580C);
    const selectedBgColor = Color(0xFFFFF7ED);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = cat.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? selectedBorderColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? selectedBorderColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFED7AA)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                cat.icon,
                color: isSelected ? selectedBorderColor : const Color(0xFF64748B),
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cat.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? selectedBorderColor : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Header ─────────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Row(
            children: [
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEA580C),
                ),
              ),
              SizedBox(width: 2),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFFEA580C),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── What's Happening Card Container ────────────────────────────────────
  Widget _buildWhatsHappeningCard() {
    final filtered = _whatsHappeningList;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: filtered.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isLast = idx == filtered.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.vertical(
                  top: idx == 0 ? const Radius.circular(20) : Radius.zero,
                  bottom: isLast ? const Radius.circular(20) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: item.iconBgColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            item.status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── My Communities Horizontal Scroll ───────────────────────────────────
  Widget _buildMyCommunitiesList() {
    return SizedBox(
      height: 226,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _myCommunities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, index) {
          final community = _myCommunities[index];
          return _buildCommunityCardItem(community);
        },
      ),
    );
  }

  Widget _buildCommunityCardItem(MyCommunityItem community) {
    return Container(
      width: 172,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Top Half with gradient and icon squircle
          Container(
            height: 94,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: community.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      community.logoIcon,
                      color: community.gradientColors.first,
                      size: 28,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Half Details
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  community.memberCount,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                // Active Today Indicator
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      community.activeTodayCount,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Overlapping Avatar Stack
                Row(
                  children: [
                    SizedBox(
                      width: 72,
                      height: 26,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: _avatarCircle(community.avatarUrls[0]),
                          ),
                          Positioned(
                            left: 16,
                            child: _avatarCircle(community.avatarUrls[1]),
                          ),
                          Positioned(
                            left: 32,
                            child: _avatarCircle(community.avatarUrls[2]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${community.overflowCount}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                  color: Color(0xFFEA580C),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarCircle(String url) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.8),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ── Recommended for you Section ────────────────────────────────────────
  Widget _buildRecommendedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _recommendedCommunities.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isLast = idx == _recommendedCommunities.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: item.iconBgColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.iconColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${item.memberCount} • ${item.tag}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Join Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          item.isJoined = !item.isJoined;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              item.isJoined
                                  ? 'Joined ${item.title}'
                                  : 'Left ${item.title}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: item.isJoined
                              ? const Color(0xFFEA580C)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFEA580C),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          item.isJoined ? 'Joined' : 'Join',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: item.isJoined
                                ? Colors.white
                                : const Color(0xFFEA580C),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Navigation Drawer ─────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context, String userName, String email) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEA580C), Color(0xFFF97316)],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'C',
                style: const TextStyle(
                  color: Color(0xFFEA580C),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            accountName: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(email),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz_rounded, color: Color(0xFFEA580C)),
            title: const Text('Switch Role'),
            onTap: () {
              Navigator.pop(context);
              RoleSwitcherSheet.show(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded, color: Color(0xFFEA580C)),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined, color: Color(0xFFEA580C)),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              _openNotificationsScreen();
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
            title: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authViewModelProvider.notifier).logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEAMLESS FLOATING BOTTOM NAVIGATION BAR
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
                painter: _NavPainter(
                  fillColor: Colors.white,
                  borderColor: const Color(0xFFE2E8F0),
                  shadowColor: Colors.black.withValues(alpha: 0.08),
                ),
                child: SizedBox(
                  height: _navBarHeight,
                  child: Row(
                    children: [
                      _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                      _navItem(1, Icons.people_outline_rounded, Icons.people_rounded, 'Community'),
                      const SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Messages'),
                      _navItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Notch FAB Button
          Positioned(
            top: _fabTop,
            left: 0,
            right: 0,
            child: Center(child: _fabButton()),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    const selectedColor = Color(0xFFEA580C);
    const unselectedColor = Color(0xFF94A3B8);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? selectedColor : unselectedColor,
              size: 23,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fabButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: _fabSize,
        height: _fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEA580C), Color(0xFFF97316)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEA580C).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}

class _NavPainter extends CustomPainter {
  const _NavPainter({
    required this.fillColor,
    required this.borderColor,
    required this.shadowColor,
  });

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
      ..cubicTo(
        centerX - notchW + 10,
        0,
        centerX - notchR * 1.1,
        notchR * 0.06,
        centerX - notchR,
        notchR * 0.35,
      )
      ..cubicTo(
        centerX - notchR * 0.92,
        notchR * 0.6,
        centerX - notchR * 0.75,
        notchR * 0.85,
        centerX - notchR * 0.5,
        notchR * 0.98,
      )
      ..cubicTo(
        centerX - notchR * 0.28,
        notchR * 1.05,
        centerX - 14,
        notchR * 1.06,
        centerX,
        notchR * 1.06,
      )
      ..cubicTo(
        centerX + 14,
        notchR * 1.06,
        centerX + notchR * 0.28,
        notchR * 1.05,
        centerX + notchR * 0.5,
        notchR * 0.98,
      )
      ..cubicTo(
        centerX + notchR * 0.75,
        notchR * 0.85,
        centerX + notchR * 0.92,
        notchR * 0.6,
        centerX + notchR,
        notchR * 0.35,
      )
      ..cubicTo(
        centerX + notchR * 1.1,
        notchR * 0.06,
        centerX + notchW - 10,
        0,
        centerX + notchW,
        0,
      )
      ..lineTo(w - cornerRadius, 0)
      ..arcToPoint(
        Offset(w, cornerRadius),
        radius: const Radius.circular(cornerRadius),
      )
      ..lineTo(w, h - cornerRadius)
      ..arcToPoint(
        Offset(w - cornerRadius, h),
        radius: const Radius.circular(cornerRadius),
      )
      ..quadraticBezierTo(centerX, h - bottomArc, cornerRadius, h)
      ..arcToPoint(
        Offset(0, h - cornerRadius),
        radius: const Radius.circular(cornerRadius),
      )
      ..lineTo(0, cornerRadius)
      ..arcToPoint(
        Offset(cornerRadius, 0),
        radius: const Radius.circular(cornerRadius),
      )
      ..close();

    canvas.drawShadow(path, shadowColor, 20, true);
    canvas.drawPath(path, Paint()..style = PaintingStyle.fill..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(covariant _NavPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.shadowColor != shadowColor;
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.color, this.onTap);
}
