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
  int _selectedBottomNavIndex = 1; // 1 represents Community tab
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
      iconColor: Color(0xFF7C3AED),
      iconBgColor: Color(0xFFF3E8FF),
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
        gradientColors: const [Color(0xFF7C3AED), Color(0xFF9333EA)],
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
      // Center Floating Action Button (+) clicked
      _openCreatePostScreen();
      return;
    }
    if (index == 4) {
      // Profile tab tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Member';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: _buildDrawer(context, userName, session?.email ?? ''),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Top Bar & Search ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  children: [
                    _buildAppBar(context),
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                  ],
                ),
              ),
            ),

            // ── Category Filter Tags ──────────────────────────────────────
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

            // ── Main Content Sections ────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 1. What's Happening Section
                  _buildSectionHeader(
                    title: "What's Happening",
                    onViewAll: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildWhatsHappeningCard(),

                  const SizedBox(height: 24),

                  // 2. My Communities Section
                  _buildSectionHeader(
                    title: 'My Communities',
                    onViewAll: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildMyCommunitiesList(),

                  const SizedBox(height: 24),

                  // 3. Recommended for you Section
                  _buildSectionHeader(
                    title: 'Recommended for you',
                    onViewAll: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildRecommendedCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  // ── App Bar ─────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF1E293B),
              size: 26,
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'Community',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
        ),
        GestureDetector(
          onTap: _openNotificationsScreen,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF1E293B),
                    size: 25,
                  ),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Search Input Bar ───────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() {}),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B),
        ),
        decoration: const InputDecoration(
          icon: Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
          hintText: 'Search communities, people, posts...',
          hintStyle: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // ── Category Filter Card ───────────────────────────────────────────────
  Widget _buildCategoryCard(CommunityCategory cat, bool isSelected) {
    const selectedBorderColor = Color(0xFF7C3AED);
    const selectedBgColor = Color(0xFFF5F3FF);

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
                    ? const Color(0xFFDDD6FE)
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
                  color: Color(0xFF7C3AED),
                ),
              ),
              SizedBox(width: 2),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFF7C3AED),
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
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${community.overflowCount}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7C3AED),
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
                              ? const Color(0xFF7C3AED)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF7C3AED),
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
                                : const Color(0xFF7C3AED),
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
                colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'C',
                style: const TextStyle(
                  color: Color(0xFF7C3AED),
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
            leading: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF7C3AED)),
            title: const Text('Switch Role'),
            onTap: () {
              Navigator.pop(context);
              RoleSwitcherSheet.show(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded, color: Color(0xFF7C3AED)),
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
            leading: const Icon(Icons.notifications_outlined, color: Color(0xFF7C3AED)),
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
                size: Size.infinite,
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
            child: _fabButton(),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    const selectedColor = Color(0xFF7C3AED);
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
            colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
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
