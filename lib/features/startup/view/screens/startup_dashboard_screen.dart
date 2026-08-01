import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/viewmodel/auth_viewmodel.dart';
import '../../model/startup_models.dart';
import '../../../auth/view/sign_in_screen.dart';
import 'fundraising_dashboard_screen.dart';
import 'hiring_command_screen.dart';
import 'investor_pipeline_screen.dart';
import 'startup_analytics_screen.dart';
import 'startup_documents_screen.dart';
import 'startup_events_screen.dart';
import 'startup_milestones_screen.dart';
import 'startup_products_screen.dart';
import 'team_command_screen.dart';

class StartupDashboardScreen extends ConsumerStatefulWidget {
  const StartupDashboardScreen({super.key, required this.startupName});
  final String startupName;

  @override
  ConsumerState<StartupDashboardScreen> createState() => _StartupDashboardScreenState();
}

class _StartupDashboardScreenState extends ConsumerState<StartupDashboardScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;
  int _selectedNavIndex = 0;
  int _selectedProfileTab = 0;
  String _industry = '';
  String _stage = '';
  String _country = '';
  String _city = '';
  String _tagline = '';
  String _ownerName = '';
  String _email = '';

  final List<ConnectionRequest> _connectionRequests = [];

  List<ActivityItem> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    await ref.read(authViewModelProvider.notifier).loadSession();
    final session = ref.read(authViewModelProvider).session;
    if (session != null && mounted) {
      setState(() {
        _industry = session.startupIndustry ?? '';
        _stage = session.startupStage ?? '';
        _country = session.startupCountry ?? session.country ?? '';
        _city = session.startupCity ?? session.city ?? '';
        _tagline = session.startupTagline ?? '';
        _ownerName = session.fullName;
        _email = session.email;
        _recentActivity = [
          ActivityItem(
            icon: _tagline.startsWith('Member of')
                ? Icons.group_add_outlined
                : Icons.rocket_launch_outlined,
            title: _tagline.startsWith('Member of')
                ? 'Joined ${widget.startupName}'
                : 'Startup profile created',
            subtitle: 'Your startup details are saved to this dashboard.',
            color: const Color(0xFF5B21B6),
          ),
        ];
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String get _locationLabel {
    final parts = <String>[];
    if (_city.isNotEmpty) {
      parts.add(_city);
    }
    if (_country.isNotEmpty) {
      parts.add(_country);
    }
    return parts.join(', ');
  }

  int get _profileCompletion {
    final filledFields = [
      widget.startupName,
      _industry,
      _stage,
      _tagline,
      _country,
      _city,
    ].where((value) => value.isNotEmpty).length;
    return (filledFields / 6 * 100).round();
  }

  String get _greetingName {
    final name = _ownerName.trim();
    if (name.isEmpty) return 'there';
    return name.split(RegExp(r'\s+')).first;
  }

  String get _profileInitials {
    final words = _ownerName.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return 'U';
    return words.take(2).map((word) => word[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── Header gradient ──
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A0E8F),
                      Color(0xFF6D28D9),
                      Color(0xFF5B21B6),
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
                        // Top row
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7C3AED),
                                    Color(0xFF5B21B6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.rocket_launch_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.startupName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified_rounded,
                                        color: Color(0xFF93C5FD),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  if (_tagline.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      _tagline,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.82,
                                        ),
                                        fontSize: 12.5,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      if (_industry.isNotEmpty)
                                        _tagChip(_industry),
                                      if (_stage.isNotEmpty) _tagChip(_stage),
                                      if (_locationLabel.isNotEmpty)
                                        _tagChip(_locationLabel),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showNotificationsSheet(),
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
                                      child: Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF87171),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _showProfileSheet(),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Greeting
                        Text(
                          'Good Morning, $_greetingName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_email.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              _email,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        Text(
                          "Here's what's happening with your startup today.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Startup score card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STARTUP SCORE',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '$_profileCompletion',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 52,
                                              fontWeight: FontWeight.w900,
                                              height: 1,
                                            ),
                                          ),
                                          const Text(
                                            '/100',
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  _CircularScoreGauge(
                                    score: _profileCompletion,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _scoreStat(
                                    '$_profileCompletion%',
                                    'PROFILE\nCOMPLETION',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    '${_recentActivity.length}',
                                    'RECENT\nACTIVITIES',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    widget.startupName.isNotEmpty ? '1' : '0',
                                    'STARTUP\nPROFILES',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _scoreStat(
                                    _stage.isNotEmpty ? '1' : '0',
                                    'STAGE\nSET',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    _country.isNotEmpty ? '1' : '0',
                                    'LOCATION\nSET',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    _tagline.isNotEmpty ? '1' : '0',
                                    'TAGLINE\nSET',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        // Profile tabs
                        _ProfileTabsRow(
                          selectedIndex: _selectedProfileTab,
                          onTabChanged: (index) =>
                              setState(() => _selectedProfileTab = index),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Body ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Quick Actions
                  _SectionHeader(title: 'Quick Actions', onSeeAll: null),
                  const SizedBox(height: 12),
                  _QuickActionsGrid(
                    onPostUpdate: () => _showSnack('Post Update'),
                    onAddMember: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TeamCommandScreen(startupName: widget.startupName),
                      ),
                    ),
                    onRaiseFund: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FundraisingDashboardScreen(
                          startupName: widget.startupName,
                        ),
                      ),
                    ),
                    onCreateJob: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HiringCommandScreen(
                          startupName: widget.startupName,
                        ),
                      ),
                    ),
                    onAddProduct: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StartupProductsScreen(
                          startupName: widget.startupName,
                        ),
                      ),
                    ),
                    onEvent: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StartupEventsScreen(
                          startupName: widget.startupName,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Connection Requests
                  _SectionHeader(
                    title: 'Connection Requests',
                    onSeeAll: () => _showSnack('View all requests'),
                  ),
                  const SizedBox(height: 12),
                  if (_connectionRequests.isEmpty)
                    _emptySection(
                      icon: Icons.people_outline,
                      message: 'No connection requests yet.',
                    )
                  else
                    ..._connectionRequests.asMap().entries.map((e) {
                      final i = e.key;
                      final req = e.value;
                      return _ConnectionRequestCard(
                        request: req,
                        onAccept: () =>
                            setState(() => _connectionRequests.removeAt(i)),
                        onIgnore: () =>
                            setState(() => _connectionRequests.removeAt(i)),
                      );
                    }),

                  const SizedBox(height: 24),

                  // AI Insights
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'AI Insights',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Improve your funding profile by adding your latest financial statements to attract more institutional investors.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InvestorPipelineScreen(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'View Recommendations',
                                  style: TextStyle(
                                    color: Color(0xFF5B21B6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF5B21B6),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent Activity
                  _SectionHeader(title: 'Recent Activity', onSeeAll: null),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _recentActivity.asMap().entries.map((e) {
                        final isLast = e.key == _recentActivity.length - 1;
                        return _ActivityTile(item: e.value, isLast: isLast);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Management Grid
                  _SectionHeader(title: 'Manage', onSeeAll: null),
                  const SizedBox(height: 12),
                  _ManagementGrid(startupName: widget.startupName),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: _handleBottomNav,
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _emptySection({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF)),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _scoreStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 36,
    color: Colors.white.withValues(alpha: 0.15),
  );

  void _handleBottomNav(int index) {
    setState(() => _selectedNavIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        _showSnack('Network coming soon');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _selectedNavIndex = 0);
        });
        break;
      case 2:
        _showCreateSheet();
        break;
      case 3:
        _showSnack('Messages coming soon');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _selectedNavIndex = 0);
        });
        break;
      case 4:
        _showStartupQuickMenu();
        break;
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
      );
  }

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
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
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            const SizedBox(height: 14),
            if (_recentActivity.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'No notifications yet.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              )
            else
              ..._recentActivity.map(
                (item) =>
                    _notifTile(item.icon, item.title, 'Just now', item.color),
              ),
          ],
        ),
      ),
    );
  }

  Widget _notifTile(IconData icon, String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF12233D),
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFFEDE9FE),
              child: Text(
                _profileInitials,
                style: const TextStyle(
                  color: Color(0xFF5B21B6),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _ownerName.isEmpty ? 'Your profile' : _ownerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            const Text(
              'Startup member',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 20),
            _sheetAction(
              Icons.logout_rounded,
              'Sign Out',
              const Color(0xFFDC2626),
              () async {
                final nav = Navigator.of(context);
                Navigator.pop(ctx);
                await ref.read(authViewModelProvider.notifier).logout();
                if (!mounted) return;
                nav.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 30,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                  child: Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4A0E8F), Color(0xFF6D28D9)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(26)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.add_box_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Create New',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Choose what you want to publish from the startup hub.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.35,
                                color: Colors.white.withValues(alpha: 0.84),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                  child: Column(
                    children: [
                      _createActionCard(
                        ctx,
                        icon: Icons.event_outlined,
                        title: 'Create Event',
                        subtitle:
                            'Host a meetup, demo day, investor panel, or community session.',
                        accent: const Color(0xFF6D28D9),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StartupEventsScreen(
                              startupName: widget.startupName,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _createActionCard(
                        ctx,
                        icon: Icons.work_outline,
                        title: 'Create a Job Post',
                        subtitle:
                            'Publish a new role and start collecting applicants.',
                        accent: const Color(0xFFD97706),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HiringCommandScreen(
                              startupName: widget.startupName,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _createActionCard(
                        ctx,
                        icon: Icons.inventory_2_outlined,
                        title: 'Add product',
                        subtitle:
                            'Showcase a launch, release note, or new offer.',
                        accent: const Color(0xFF7C3AED),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StartupProductsScreen(
                              startupName: widget.startupName,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _createActionCard(
                        ctx,
                        icon: Icons.post_add_outlined,
                        title: 'Post update',
                        subtitle:
                            'Share company news with your team and followers.',
                        accent: const Color(0xFF2563EB),
                        onTap: () => _showSnack('Post update coming soon'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createActionCard(
    BuildContext ctx, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accent.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.16),
                    accent.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: accent, size: 23),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.8,
                      height: 1.4,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_right_rounded, color: accent, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  void _showStartupQuickMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
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
            const Text(
              'Startup Hub',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            const SizedBox(height: 14),
            _menuItem(
              ctx,
              Icons.analytics_outlined,
              'Analytics',
              const Color(0xFF5B21B6),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StartupAnalyticsScreen(),
                ),
              ),
            ),
            _menuItem(
              ctx,
              Icons.flag_outlined,
              'Milestones',
              const Color(0xFF2563EB),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StartupMilestonesScreen(),
                ),
              ),
            ),
            _menuItem(
              ctx,
              Icons.folder_outlined,
              'Documents',
              const Color(0xFF059669),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StartupDocumentsScreen(),
                ),
              ),
            ),
            _menuItem(
              ctx,
              Icons.people_outline,
              'Investors',
              const Color(0xFFF59E0B),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InvestorPipelineScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext ctx,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF12233D),
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile Tabs Row ──
class _ProfileTabsRow extends StatelessWidget {
  const _ProfileTabsRow({
    required this.selectedIndex,
    required this.onTabChanged,
  });
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = ['Overview', 'Team', 'Products', 'Posts'];
    return Row(
      children: tabs.asMap().entries.map((e) {
        final selected = e.key == selectedIndex;
        return GestureDetector(
          onTap: () => onTabChanged(e.key),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              e.value,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF5B21B6)
                    : Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Circular Score Gauge ──
class _CircularScoreGauge extends StatelessWidget {
  const _CircularScoreGauge({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _GaugePainter(score / 100),
        child: Center(
          child: Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter(this.fraction);
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    const startAngle = -3.14 / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * 3.14159 * fraction,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.fraction != fraction;
}

// ── Section Header ──
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF12233D),
          ),
        ),
        const Spacer(),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFF5B21B6),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Quick Actions Grid ──
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.onPostUpdate,
    required this.onAddMember,
    required this.onRaiseFund,
    required this.onCreateJob,
    required this.onAddProduct,
    required this.onEvent,
  });
  final VoidCallback onPostUpdate,
      onAddMember,
      onRaiseFund,
      onCreateJob,
      onAddProduct,
      onEvent;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.post_add_outlined,
        label: 'Post Update',
        color: const Color(0xFF5B21B6),
        onTap: onPostUpdate,
      ),
      _QuickAction(
        icon: Icons.person_add_outlined,
        label: 'Add Member',
        color: const Color(0xFF2563EB),
        onTap: onAddMember,
      ),
      _QuickAction(
        icon: Icons.trending_up,
        label: 'Raise Fund',
        color: const Color(0xFF059669),
        onTap: onRaiseFund,
      ),
      _QuickAction(
        icon: Icons.work_outline,
        label: 'Create Job',
        color: const Color(0xFFD97706),
        onTap: onCreateJob,
      ),
      _QuickAction(
        icon: Icons.inventory_2_outlined,
        label: 'Add Product',
        color: const Color(0xFF7C3AED),
        onTap: onAddProduct,
      ),
      _QuickAction(
        icon: Icons.event_outlined,
        label: 'Event',
        color: const Color(0xFF0891B2),
        onTap: onEvent,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: actions.map((a) => _QuickActionCell(action: a)).toList(),
      ),
    );
  }
}

class _QuickActionCell extends StatelessWidget {
  const _QuickActionCell({required this.action});
  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(action.icon, color: action.color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

// ── Connection Request Card ──
class _ConnectionRequestCard extends StatelessWidget {
  const _ConnectionRequestCard({
    required this.request,
    required this.onAccept,
    required this.onIgnore,
  });
  final ConnectionRequest request;
  final VoidCallback onAccept, onIgnore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFEDE9FE),
            child: Text(
              request.initials,
              style: const TextStyle(
                color: Color(0xFF5B21B6),
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                Text(
                  request.role,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAccept,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF5B21B6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onIgnore,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD1D5DB)),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Ignore',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Activity Tile ──
class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item, required this.isLast});
  final ActivityItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF12233D),
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Management Grid ──
class _ManagementGrid extends StatelessWidget {
  const _ManagementGrid({required this.startupName});
  final String startupName;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MgmtItem(
        icon: Icons.people_outline,
        label: 'Team',
        color: const Color(0xFF5B21B6),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeamCommandScreen(startupName: startupName),
          ),
        ),
      ),
      _MgmtItem(
        icon: Icons.work_outline,
        label: 'Hiring',
        color: const Color(0xFF2563EB),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HiringCommandScreen(startupName: startupName),
          ),
        ),
      ),
      _MgmtItem(
        icon: Icons.trending_up,
        label: 'Fundraising',
        color: const Color(0xFF059669),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FundraisingDashboardScreen(startupName: startupName),
          ),
        ),
      ),
      _MgmtItem(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Investors',
        color: const Color(0xFFF59E0B),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InvestorPipelineScreen()),
        ),
      ),
      _MgmtItem(
        icon: Icons.inventory_2_outlined,
        label: 'Products',
        color: const Color(0xFF7C3AED),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StartupProductsScreen(startupName: startupName),
          ),
        ),
      ),
      _MgmtItem(
        icon: Icons.analytics_outlined,
        label: 'Analytics',
        color: const Color(0xFF0891B2),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StartupAnalyticsScreen()),
        ),
      ),
      _MgmtItem(
        icon: Icons.flag_outlined,
        label: 'Milestones',
        color: const Color(0xFFE11D48),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StartupMilestonesScreen()),
        ),
      ),
      _MgmtItem(
        icon: Icons.folder_outlined,
        label: 'Documents',
        color: const Color(0xFF6B7280),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StartupDocumentsScreen()),
        ),
      ),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: items
          .map(
            (item) => GestureDetector(
              onTap: item.onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(item.icon, color: item.color, size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MgmtItem {
  const _MgmtItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

// ── Bottom Navigation Bar ──
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
              _navItem(
                1,
                Icons.people_outline,
                Icons.people_rounded,
                'Network',
              ),
              _addButton(),
              _navItem(
                3,
                Icons.chat_bubble_outline,
                Icons.chat_bubble_rounded,
                'Messages',
              ),
              _navItem(
                4,
                Icons.rocket_launch_outlined,
                Icons.rocket_launch_rounded,
                'Startup',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected
                  ? const Color(0xFF5B21B6)
                  : const Color(0xFF9CA3AF),
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? const Color(0xFF5B21B6)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(2),
        child: Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x305B21B6),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
