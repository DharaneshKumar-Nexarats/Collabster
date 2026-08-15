import 'package:flutter/material.dart';

// ─── Color Tokens ───────────────────────────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF059669);
const _accentLight = Color(0xFF10B981);
const _accentBg = Color(0xFFECFDF5);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);


class ConferencesScreen extends StatefulWidget {
  const ConferencesScreen({super.key});

  @override
  State<ConferencesScreen> createState() => _ConferencesScreenState();
}

class _ConferencesScreenState extends State<ConferencesScreen> {
  int _selectedFilterIndex = 0;
  int _bottomNavIndex = 0;

  final List<String> _filters = ['All', 'Tech', 'Entrepreneurship', 'Research'];

  final List<Map<String, dynamic>> _conferences = [
    {
      'title': 'Future of AI 2024',
      'location': 'Stanford University • San Francisco',
      'tags': ['₹1,500 onwards', 'IEEE Track', 'Paper Presentation', 'GenAI'],
      'tagColors': [null, null, null, null],
      'badge': 'NEW',
      'badgeColor': Color(0xFFFF3C5C),
      'gradient': [Color(0xFF0A1628), Color(0xFF1B3A6B), Color(0xFF2D5F9E)],
      'icon': Icons.auto_awesome_rounded,
      'iconColor': Color(0xFF93C5FD),
      'ctaLabel': 'Get Ticket',
    },
    {
      'title': 'Global Startup Summit',
      'location': 'IIT Bombay • Mumbai',
      'tags': ['Free Entry', 'Pitch Competition', 'Networking', 'SaaS'],
      'tagColors': [Color(0xFF22C55E), null, null, null],
      'badge': null,
      'gradient': [Color(0xFF1A2A0A), Color(0xFF2E4A10), Color(0xFF3D6B1A)],
      'icon': Icons.rocket_launch_rounded,
      'iconColor': Color(0xFF86EFAC),
      'ctaLabel': 'Get Ticket',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 14),
                    _buildFilterChips(),
                    const SizedBox(height: 18),
                    ..._conferences.map((c) => _buildConferenceCard(context, c)),
                    const SizedBox(height: 4),
                    _buildFlashSaleCard(),
                    const SizedBox(height: 20),
                    _buildViewAllButton(),
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

  // ─── Top Bar ─────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _surface, shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Conferences',
                style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w900)),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _surface, shape: BoxShape.circle,
              border: Border.all(color: _borderColor),
            ),
            child: const Icon(Icons.notifications_outlined, color: _textPrimary, size: 18),
          ),
          const SizedBox(width: 10),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_accentLight, _accent],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('R',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ──────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
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
          Text('Search conferences...', style: TextStyle(color: _textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  // ─── Filter Chips ────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (i) {
          final isSelected = _selectedFilterIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _accent : _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _accent : _borderColor,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(_filters[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  )),
            ),
          );
        }),
      ),
    );
  }

  // ─── Conference Card ─────────────────────────────────────────
  Widget _buildConferenceCard(BuildContext context, Map<String, dynamic> c) {
    final tags = c['tags'] as List<String>;
    final tagColors = c['tagColors'] as List<Color?>;
    final gradients = c['gradient'] as List<Color>;
    final hasBadge = c['badge'] != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / gradient header
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Container(
              height: 148,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradients,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Audience dots pattern via CustomPaint (no nested for-loops in Stack)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DotPatternPainter(),
                    ),
                  ),
                  // Stage glow
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            (c['iconColor'] as Color).withOpacity(0.12),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Center icon
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.15)),
                          ),
                          child: Icon(c['icon'] as IconData,
                              color: c['iconColor'] as Color, size: 26),
                        ),
                      ],
                    ),
                  ),
                  // NEW badge
                  if (hasBadge)
                    Positioned(
                      top: 12, right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: c['badgeColor'] as Color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.circle, color: Colors.white, size: 6),
                            const SizedBox(width: 4),
                            Text(c['badge'] as String,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  // Bookmark top-left icon placeholder
                  Positioned(
                    bottom: 10, left: 12,
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.photo_camera_outlined,
                          color: Colors.white54, size: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Card body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['title'] as String,
                    style: const TextStyle(
                        color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: _textSecondary, size: 13),
                    const SizedBox(width: 4),
                    Text(c['location'] as String,
                        style: const TextStyle(color: _textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: List.generate(tags.length, (i) {
                    final tagColor = tagColors[i];
                    final isFreeEntry = tagColor != null;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isFreeEntry
                            ? tagColor.withOpacity(0.15)
                            : _accentBg,
                        borderRadius: BorderRadius.circular(20),
                        border: isFreeEntry
                            ? Border.all(color: tagColor.withOpacity(0.4))
                            : null,
                      ),
                      child: Text(tags[i],
                          style: TextStyle(
                              color: isFreeEntry ? tagColor : _accentLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w500)),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _borderColor),
                      ),
                      child: const Icon(Icons.bookmark_border_rounded,
                          color: _textSecondary, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(c['ctaLabel'] as String,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
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

  // ─── Flash Sale Card ─────────────────────────────────────────
  Widget _buildFlashSaleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flash Sale badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, color: _accentLight, size: 12),
                SizedBox(width: 4),
                Text('Flash Sale',
                    style: TextStyle(
                        color: _accentLight, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('UX Design\nConference 2024',
              style: TextStyle(
                  color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w900, height: 1.25)),
          const SizedBox(height: 6),
          const Text('Early bird ends in 2 days',
              style: TextStyle(color: _textSecondary, fontSize: 12)),
          const SizedBox(height: 14),
          Row(
            children: [
              // Prices
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('₹999',
                      style: TextStyle(
                          color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w900)),
                  Text('₹1999',
                      style: TextStyle(
                          color: _textSecondary.withOpacity(0.7),
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: _textSecondary.withOpacity(0.7))),
                ],
              ),
              const Spacer(),
              // Reserve Now button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Reserve Now',
                    style: TextStyle(
                        color: _accent, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── View All Button ─────────────────────────────────────────
  Widget _buildViewAllButton() {
    return Center(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _accent, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('View All',
            style: TextStyle(color: _accentLight, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  // ─── Bottom Navigation ───────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'label': 'Explore'},
      {'icon': Icons.add_circle_outline_rounded, 'label': 'Applied'},
      {'icon': Icons.bookmark_border_rounded, 'label': 'Saved'},
    ];
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final isSelected = _bottomNavIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _bottomNavIndex = i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(items[i]['icon'] as IconData,
                      size: 22,
                      color: isSelected ? _accentLight : _textSecondary),
                  const SizedBox(height: 3),
                  Text(items[i]['label'] as String,
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

// ─── Dot Pattern Painter ─────────────────────────────────────
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    const rows = 5;
    const cols = 7;
    final colSpacing = size.width / cols;
    const rowSpacing = 22.0;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final dx = col * colSpacing + (row.isOdd ? colSpacing / 2 : 0);
        final dy = row * rowSpacing + 10;
        canvas.drawCircle(Offset(dx, dy), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
