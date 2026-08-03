import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';
import 'resume_upgrade_screen.dart';


class ATSScoreScreen extends StatelessWidget {
  const ATSScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar & Content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                Positioned(
                                  right: 1,
                                  top: 1,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFBBF24),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?img=47'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Title
                      const Text(
                        'ATS Score',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Profile Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: const Color(0xFFEDE9FF), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Alex Rivera',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2C2560),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'SENIOR PRODUCT DESIGNER',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?img=33'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: Color(0xFFF3F0FF), height: 1, thickness: 1.2),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.email_outlined,
                                    color: Color(0xFF5B4FCF), size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'alex.riv@sphere.io',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey.shade700),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.location_on_outlined,
                                    color: Color(0xFF5B4FCF), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'San Francisco, CA',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            // Core Expertise Indicator
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5B4FCF),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'CORE EXPERTISE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5B4FCF),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const [
                                _ExpertiseTag(label: 'UI/UX Strategy'),
                                _ExpertiseTag(label: 'Design Systems'),
                                _ExpertiseTag(label: 'React Framework'),
                                _ExpertiseTag(label: 'Prototyping'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Download & Edit Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.file_download_outlined,
                                  color: Colors.white, size: 18),
                              label: const Text(
                                'Download PDF',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B4FCF),
                                minimumSize: const Size(0, 48),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Color(0xFF5B4FCF),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ATS Optimization Title with AI badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ATS Optimization',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EDFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.auto_awesome,
                                    color: Color(0xFF5B4FCF), size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'Powered by AI',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5B4FCF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Gauge in center
                      Center(
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: CustomPaint(
                            painter: _GaugePainter(percentage: 0.85),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '85%',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C2560),
                                    ),
                                  ),
                                  Text(
                                    'GOOD SCORE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Suggestion cards
                      const _SuggestionCard(
                        icon: Icons.check_circle_outline_rounded,
                        title: 'Add more achievements',
                        desc:
                            "Mention specific numbers (e.g. \"Increased sales by 20%\").",
                      ),
                      const SizedBox(height: 12),
                      const _SuggestionCard(
                        icon: Icons.add_circle_outline_rounded,
                        title: 'Include keywords',
                        desc:
                            "Add \"Cloud Architecture\" and \"DevOps\" to your skills.",
                      ),
                      const SizedBox(height: 24),

                      // Review & Enhance Pro card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResumeUpgradeScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9FF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF5B4FCF), width: 1.5),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lock_open_rounded,
                                        color: Color(0xFF5B4FCF), size: 18),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Review & Enhance',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5B4FCF),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2C2560),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'PRO',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                  color: Color(0xFF5B4FCF), height: 1, thickness: 1),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Text(
                                      '\$9.99/mo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C2560),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '\$19.99',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade400,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEE2E2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        '50% OFF',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFEF4444),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      'Upgrade to Pro',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5B4FCF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(true, Icons.home_rounded, 'Home'),
                      _buildNavItem(false, Icons.explore_outlined, 'Explore'),
                      _buildCenterAddButton(context),
                      _buildNavItem(false, Icons.work_outline, 'Applied'),
                      _buildNavItem(false, Icons.bookmark_border, 'Saved'),
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

  Widget _buildNavItem(bool isSelected, IconData icon, String label) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFE5DFFF),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey.shade500,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAddButton(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x406B4EFF),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 26),
    );
  }
}

class _ExpertiseTag extends StatelessWidget {
  final String label;
  const _ExpertiseTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B4FCF),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _SuggestionCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF5B4FCF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.4,
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

class _GaugePainter extends CustomPainter {
  final double percentage;
  const _GaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 9.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final bgPaint = Paint()
      ..color = const Color(0xFFEDE9FF)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc (gauge)
    final fgPaint = Paint()
      ..color = const Color(0xFF5B4FCF)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
