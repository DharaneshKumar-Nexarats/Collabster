import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'internships_screen.dart';
import 'jobs_screen.dart';
import 'freelance_screen.dart';
import 'resume_screen.dart';
import 'mock_interviews_screen.dart';
import 'notifications_screen.dart';



class CareerDashboardScreen extends StatelessWidget {
  final VoidCallback onInternshipsTap;
  final VoidCallback? onJobsTap;
  final VoidCallback? onFreelanceTap;
  final VoidCallback? onResumeTap;
  final VoidCallback? onMocksTap;
  const CareerDashboardScreen({
    super.key,
    required this.onInternshipsTap,
    this.onJobsTap,
    this.onFreelanceTap,
    this.onResumeTap,
    this.onMocksTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DarkHeader(
            onInternshipsTap: onInternshipsTap,
            onJobsTap: onJobsTap,
            onFreelanceTap: onFreelanceTap,
            onResumeTap: onResumeTap,
            onMocksTap: onMocksTap,
          ),
          _WhiteContent(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DARK HEADER WIDGET
// ═══════════════════════════════════════════════════════════════════════════
class _DarkHeader extends StatelessWidget {
  final VoidCallback onInternshipsTap;
  final VoidCallback? onJobsTap;
  final VoidCallback? onFreelanceTap;
  final VoidCallback? onResumeTap;
  final VoidCallback? onMocksTap;
  
  const _DarkHeader({
    required this.onInternshipsTap,
    this.onJobsTap,
    this.onFreelanceTap,
    this.onResumeTap,
    this.onMocksTap,
  });

  static const _chipLabels = ['Jobs', 'Internships', 'Freelance', 'Resume', 'Mocks'];
  static const _chipIcons  = [
    Icons.work_outline_rounded,
    Icons.school_outlined,
    Icons.laptop_mac_outlined,
    Icons.description_outlined,
    Icons.mic_none_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A2E),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _greetingRow(context),
              const SizedBox(height: 16),
              _searchBar(),
              const SizedBox(height: 16),
              _boostCard(),
              const SizedBox(height: 22),
              _chipRow(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Greeting ──────────────────────────────────────────────────────────
  Widget _greetingRow(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 21,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Hi Sarah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Ready for your next move?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Bell + yellow dot
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationsScreen(),
              ),
            );
          },
          child: SizedBox(
            width: 38,
            height: 38,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                ),
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFBBF24),
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

  // ── Search bar (NO TextField — avoids pixel issues) ───────────────────
  Widget _searchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search jobs, internships, freelance...',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune_rounded,
                color: AppColors.primary, size: 16),
          ),
        ],
      ),
    );
  }

  // ── Boost Your Profile card ───────────────────────────────────────────
  Widget _boostCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF5145E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Boost Your Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Make your profile impossible to ignore.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    color: Color(0xFF5145E0),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_rounded,
                    size: 14, color: Color(0xFF5145E0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Category chips ────────────────────────────────────────────────────
  Widget _chipRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_chipLabels.length, (i) {
        return GestureDetector(
          onTap: () {
            if (i == 0) {
              if (onJobsTap != null) {
                onJobsTap!();
              } else {
                Navigator.push(
                  context,
                  SmoothRightToLeftPageRoute(
                    builder: (context) => const JobsScreen(),
                  ),
                );
              }
            } else if (i == 1) {
              onInternshipsTap();
            } else if (i == 2) {
              if (onFreelanceTap != null) {
                onFreelanceTap!();
              } else {
                Navigator.push(
                  context,
                  SmoothRightToLeftPageRoute(
                    builder: (context) => const FreelanceScreen(),
                  ),
                );
              }
            } else if (i == 3) {
              if (onResumeTap != null) {
                onResumeTap!();
              } else {
                Navigator.push(
                  context,
                  SmoothRightToLeftPageRoute(
                    builder: (context) => const ResumeScreen(),
                  ),
                );
              }
            } else if (i == 4) {
              if (onMocksTap != null) {
                onMocksTap!();
              } else {
                Navigator.push(
                  context,
                  SmoothRightToLeftPageRoute(
                    builder: (context) => MockInterviewsScreen(
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                );
              }
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1,
                  ),
                ),
                child: Icon(_chipIcons[i], color: Colors.white70, size: 22),
              ),
              const SizedBox(height: 7),
              Text(
                _chipLabels[i],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// WHITE CONTENT WIDGET
// ═══════════════════════════════════════════════════════════════════════════
class _WhiteContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Opportunity Feed ────────────────────────────────────────
            _SectionHeader(title: 'Opportunity Feed', cta: 'View all'),
            const SizedBox(height: 4),
            Text(
              'Based on your skills in UI & React',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _JobCard(
                    title: 'Frontend Developer',
                    company: 'Google',
                    location: 'Remote',
                    tags: ['React', 'Tailwind'],
                    status: 'Active',
                    accent: Color(0xFF4F46E5),
                    statusBg: Color(0xFFDCFCE7),
                    statusFg: Color(0xFF15803D),
                  ),
                  SizedBox(width: 12),
                  _JobCard(
                    title: 'Figma UI Designer',
                    company: 'Figma Inc.',
                    location: 'Hybrid',
                    tags: ['Figma', 'Prototyping'],
                    status: 'Active',
                    accent: Color(0xFF0EA5E9),
                    statusBg: Color(0xFFDCFCE7),
                    statusFg: Color(0xFF15803D),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ── Build your resume ───────────────────────────────────────
            _SectionHeader(title: 'Build your resume', cta: 'View All'),
            const SizedBox(height: 14),
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _ResumeCard(
                    title: 'Professional Template',
                    desc: 'Optimized for tech recruiters.',
                    colorA: Color(0xFF6B4EFF),
                    colorB: Color(0xFF3B21F4),
                  ),
                  SizedBox(width: 12),
                  _ResumeCard(
                    title: 'Creative Template',
                    desc: 'Stand out with style.',
                    colorA: Color(0xFF0EA5E9),
                    colorB: Color(0xFF7C3AED),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ── Practice for Interviews ─────────────────────────────────
            _SectionHeader(title: 'Practice for Interviews', cta: 'View All'),
            const SizedBox(height: 14),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _PracticeCard(
                    title: 'AI Mock Interview',
                    desc: 'Simulate a live video interview with AI feedback.',
                    icon: Icons.smart_toy_outlined,
                    iconBg: Color(0xFFEDE9FF),
                    iconFg: Color(0xFF6B4EFF),
                  ),
                  SizedBox(width: 12),
                  _PracticeCard(
                    title: 'Coding Challenge',
                    desc: 'Solve algorithmic problems in our custom IDE.',
                    icon: Icons.code_rounded,
                    iconBg: Color(0xFFD1FAE5),
                    iconFg: Color(0xFF059669),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ── Freelance Picks ─────────────────────────────────────────
            _SectionHeader(title: 'Freelance Picks', cta: 'View All'),
            const SizedBox(height: 14),
            const _FreelanceCard(
              title: 'E-commerce Landing Page',
              price: '\$2,400',
              duration: '2 weeks',
              tags: ['Shopify', 'UI Design'],
              rating: '4.9',
              reviews: '12',
              hot: true,
            ),
            const SizedBox(height: 12),
            const _FreelanceCard(
              title: 'SaaS Dashboard UI',
              price: '\$3,800',
              duration: '3 weeks',
              tags: ['React', 'Figma'],
              rating: '5.0',
              reviews: '8',
              hot: false,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;
  final String cta;
  const _SectionHeader({required this.title, required this.cta});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            letterSpacing: -0.2,
          ),
        ),
        Text(
          cta,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Job Card ──────────────────────────────────────────────────────────────
class _JobCard extends StatelessWidget {
  final String title, company, location, status;
  final List<String> tags;
  final Color accent, statusBg, statusFg;

  const _JobCard({
    required this.title,
    required this.company,
    required this.location,
    required this.status,
    required this.tags,
    required this.accent,
    required this.statusBg,
    required this.statusFg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.grid_view_rounded, color: accent, size: 18),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),

          // Company · location
          Text(
            '$company • $location',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 10),

          // Tags
          Row(
            children: tags.take(2).map((t) {
              return Container(
                margin: const EdgeInsets.only(right: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  t,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              );
            }).toList(),
          ),

          const Spacer(),

          // Apply + Bookmark
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(0, 36),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDDD8FF)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bookmark_border_rounded,
                    size: 17, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Resume Template Card ───────────────────────────────────────────────────
class _ResumeCard extends StatelessWidget {
  final String title, desc;
  final Color colorA, colorB;

  const _ResumeCard({
    required this.title,
    required this.desc,
    required this.colorA,
    required this.colorB,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [colorA, colorB],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorA.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mock resume lines
                ...List.generate(6, (i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    height: i == 0 ? 9 : 5,
                    width: i == 0
                        ? 80.0
                        : (i.isEven ? 130.0 : 75.0),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(i == 0 ? 0.9 : 0.35),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Use Template',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorA,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.bookmark_border_rounded,
                          size: 16, color: Colors.white),
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
}

// ─── Practice Card ─────────────────────────────────────────────────────────
class _PracticeCard extends StatelessWidget {
  final String title, desc;
  final IconData icon;
  final Color iconBg, iconFg;

  const _PracticeCard({
    required this.title,
    required this.desc,
    required this.icon,
    required this.iconBg,
    required this.iconFg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 195,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconFg, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Start Practice',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Freelance Card ─────────────────────────────────────────────────────────
class _FreelanceCard extends StatelessWidget {
  final String title, price, duration, rating, reviews;
  final List<String> tags;
  final bool hot;

  const _FreelanceCard({
    required this.title,
    required this.price,
    required this.duration,
    required this.tags,
    required this.rating,
    required this.reviews,
    required this.hot,
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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + lightning
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          height: 1.3,
                        ),
                      ),
                    ),
                    if (hot) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.bolt_rounded,
                            size: 13, color: Color(0xFFD97706)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),

                // Price · duration
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '  •  $duration',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EDFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 3),
                    Text(
                      '$rating ($reviews reviews)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Apply button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(72, 36),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text(
              'Apply',
              style:
                  TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
