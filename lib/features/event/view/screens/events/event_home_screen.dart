import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/providers.dart';
import '../../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../../auth/view/screens/profile_screen.dart';
import '../../../../career/view/screens/notifications_screen.dart';
import 'hackathons_screen.dart';
import 'workshops_screen.dart';
import 'meetups_screen.dart';
import 'conferences_screen.dart';
import 'webinars_screen.dart';

// ─── Color Tokens ───────────────────────────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF059669);
const _accentLight = Color(0xFF10B981);
const _accentBg = Color(0xFFECFDF5);
const _live = Color(0xFFFF3C5C);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

class EventHomeScreen extends ConsumerStatefulWidget {
  const EventHomeScreen({super.key});

  @override
  ConsumerState<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends ConsumerState<EventHomeScreen> {
  int _bottomNavIndex = 0;
  int _selectedDayIndex = 0;
  int _activityTabIndex = 0;

  final List<Map<String, dynamic>> _days = [
    {'day': 'MON', 'date': 12},
    {'day': 'TUE', 'date': 13},
    {'day': 'WED', 'date': 14},
    {'day': 'THU', 'date': 15},
    {'day': 'FRI', 'date': 16},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.code_rounded, 'label': 'Hackathons'},
    {'icon': Icons.edit_note_rounded, 'label': 'Workshops'},
    {'icon': Icons.people_rounded, 'label': 'Meetups'},
    {'icon': Icons.mic_rounded, 'label': 'Conferences'},
    {'icon': Icons.laptop_mac_rounded, 'label': 'Webinars'},
  ];

  final List<Map<String, dynamic>> _activityItems = [
    {
      'title': 'Product Strategy 2026',
      'subtitle': 'Jun 14 • London, UK',
      'icon': Icons.event_note_rounded,
    },
    {
      'title': 'AI Ethics Summit',
      'subtitle': 'Jun 18 • Virtual',
      'icon': Icons.psychology_rounded,
    },
  ];

  final List<Map<String, dynamic>> _topEvents = [
    {
      'title': 'Global AI Summit',
      'date': 'Oct 24 • 09:00 AM',
      'colorA': Color(0xFF064E3B),
      'colorB': Color(0xFF047857),
    },
    {
      'title': 'Fintech Innova',
      'date': 'Oct 25 • 10:00 AM',
      'colorA': Color(0xFF0F766E),
      'colorB': Color(0xFF0D9488),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Sarah';
    final initials = userName.isNotEmpty ? userName[0].toUpperCase() : 'S';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(initials, userName),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildDateStrip(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('Your Upcoming', 'View All'),
                    const SizedBox(height: 12),
                    _buildUpcomingCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Explore by Category', null),
                    const SizedBox(height: 14),
                    _buildCategoryChips(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('My Activity', 'View All'),
                    const SizedBox(height: 12),
                    _buildActivityTabs(),
                    const SizedBox(height: 12),
                    _buildActivityList(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Recommended', null),
                    const SizedBox(height: 12),
                    _buildRecommendedCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Top Events', 'VIEW ALL'),
                    const SizedBox(height: 12),
                    _buildTopEventsRow(),
                    const SizedBox(height: 24),
                    _buildRegisteredLiveSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(String initials, String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_accentLight, _accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Hi $userName ', style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                    const Text('👋', style: TextStyle(fontSize: 15)),
                  ],
                ),
                const Text('Ready for your next move?', style: TextStyle(color: _textSecondary, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _surface,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.notifications_outlined, color: _textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          const Text('Events', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: _textSecondary, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Search events, workshops...', style: TextStyle(color: _textSecondary, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _accentBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x30059669)),
            ),
            child: const Icon(Icons.tune_rounded, color: _accent, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStrip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        height: 60,
        child: Row(
          children: List.generate(_days.length, (i) {
            final isSelected = _selectedDayIndex == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDayIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: i == _days.length - 1 ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _accent : _surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isSelected ? _accent : _borderColor,
                        width: isSelected ? 1.5 : 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _days[i]['day'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white70 : _textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_days[i]['date']}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : _textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? cta) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
          if (cta != null)
            GestureDetector(
              onTap: () {},
              child: Text(cta, style: const TextStyle(color: _accentLight, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      colors: [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_circle_outline_rounded, size: 48, color: _accent),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: _live, borderRadius: BorderRadius.circular(6)),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 6),
                        SizedBox(width: 4),
                        Text('LIVE \u2022 46m 11s', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Creative UI Design Mastery',
                            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: _textSecondary, size: 13),
                            SizedBox(width: 3),
                            Text('Virtual Workspace', style: TextStyle(color: _textSecondary, fontSize: 12)),
                            SizedBox(width: 12),
                            Icon(Icons.access_time_rounded, color: _textSecondary, size: 13),
                            SizedBox(width: 3),
                            Text('14:30 PM', style: TextStyle(color: _textSecondary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(10)),
                    child: const Text('Open', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (i) {
          final cat = _categories[i];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (cat['label'] == 'Hackathons') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HackathonsScreen()),
                  );
                } else if (cat['label'] == 'Workshops') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WorkshopsScreen()),
                  );
                } else if (cat['label'] == 'Meetups') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MeetupsScreen()),
                  );
                } else if (cat['label'] == 'Conferences') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ConferencesScreen()),
                  );
                } else if (cat['label'] == 'Webinars') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WebinarsScreen()),
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _card,
                      shape: BoxShape.circle,
                      border: Border.all(color: _borderColor),
                    ),
                    child: Icon(cat['icon'] as IconData, color: _accent, size: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['label'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActivityTabs() {
    final tabs = ['Registrations', 'Watchlist', 'Recent'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = _activityTabIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _activityTabIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? _accent : _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? _accent : _borderColor),
              ),
              child: Text(tabs[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  )),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActivityList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: _activityItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: _accentBg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(item['icon'] as IconData, color: _accentLight, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] as String,
                          style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 3),
                      Text(item['subtitle'] as String, style: const TextStyle(color: _textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: _textSecondary, size: 20),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(child: Icon(Icons.event_rounded, size: 48, color: _accent)),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(8)),
                    child: const Text('JUL\n22', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, height: 1.2)),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                    child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 16),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Row(
                    children: [
                      _tagChip('Conference'),
                      const SizedBox(width: 6),
                      _tagChip('AI & ML'),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Future of Generative Intelligence',
                      style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 6),
                  const Text(
                    'Explore the boundaries of neural networks in a curated 2-day event with industry leaders.',
                    style: TextStyle(color: _textSecondary, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Register Now',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
    );
  }

  Widget _buildTopEventsRow() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: _topEvents.length,
        itemBuilder: (ctx, i) {
          final ev = _topEvents[i];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [ev['colorA'] as Color, ev['colorB'] as Color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(ev['title'] as String,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(ev['date'] as String, style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegisteredLiveSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('Registered: Live Now',
                  style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
              SizedBox(width: 8),
              Icon(Icons.circle, color: _live, size: 8),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                        gradient: LinearGradient(
                          colors: [Color(0xFF065F46), Color(0xFF0F766E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(child: Icon(Icons.ondemand_video_rounded, size: 40, color: Colors.white70)),
                    ),
                    Positioned(
                      top: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: _live, borderRadius: BorderRadius.circular(5)),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 5),
                            SizedBox(width: 3),
                            Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 12,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                    const Positioned(
                      bottom: 10,
                      left: 12,
                      child: Text('Advanced Web3...',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Join Now',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home', 'isFab': false},
      {'icon': Icons.explore_outlined, 'label': 'Explore', 'isFab': false},
      {'icon': Icons.add_rounded, 'label': '', 'isFab': true},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Messages', 'isFab': false},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile', 'isFab': false},
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isFab = item['isFab'] == true;
          final isSelected = _bottomNavIndex == i;

          if (isFab) {
            return Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_accentLight, _accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _accent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                  ),
                ),
              ),
            );
          }

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (i == 4) {
                  RoleSwitcherSheet.show(context);
                } else {
                  setState(() => _bottomNavIndex = i);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData, size: 22, color: isSelected ? _accentLight : _textSecondary),
                  const SizedBox(height: 3),
                  if ((item['label'] as String).isNotEmpty)
                    Text(item['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? _accentLight : _textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
