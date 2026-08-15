import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'application_details_screen.dart';


class InternshipDetailsScreen extends StatefulWidget {
  final String title;
  final String company;
  final String location;
  final String stipend;
  final String type;
  final List<String> tags;
  final String? about;
  final List<String>? requirements;

  const InternshipDetailsScreen({
    super.key,
    this.title = 'Frontend Developer Intern',
    this.company = 'Google',
    this.location = 'Mountain View, CA',
    this.stipend = '₹500+',
    this.type = 'Full-time • 3 Months',
    this.tags = const ['Frontend', 'React', 'Tailwind', 'JavaScript'],
    this.about,
    this.requirements,
  });

  @override
  State<InternshipDetailsScreen> createState() => _InternshipDetailsScreenState();
}

typedef JobDetailScreen = InternshipDetailsScreen;

class _InternshipDetailsScreenState extends State<InternshipDetailsScreen> {
  int _selectedTab = 0; // 0 = ABOUT, 1 = REQUIREMENTS, 2 = PERKS, 3 = SIMILAR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBannerWithHeaderCard(context),
                    const SizedBox(height: 16),
                    _buildTags(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildTabsHeader(),
                    const SizedBox(height: 20),
                    if (_selectedTab == 0) ...[
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildPerksSection(),
                      const SizedBox(height: 24),
                      _buildRequirementsSection(),
                    ] else if (_selectedTab == 1) ...[
                      _buildRequirementsSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildPerksSection(),
                    ] else if (_selectedTab == 2) ...[
                      _buildPerksSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildRequirementsSection(),
                    ] else ...[
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildRequirementsSection(),
                      const SizedBox(height: 24),
                      _buildPerksSection(),
                    ],
                    const SizedBox(height: 24),
                    _buildSimilarInternshipsSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // 1. Top Banner + Header Card overlapping
  Widget _buildTopBannerWithHeaderCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Office Banner Image
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay on banner for readability of top controls
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Top Navigation Controls (Back button, Share, Notification)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF4F46E5),
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              // Share Button
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: Color(0xFF4F46E5),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              // Bookmark Button
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  color: Color(0xFF4F46E5),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        // Floating Card
        Padding(
          padding: const EdgeInsets.only(top: 140, left: 20, right: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF0F9FF), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                              letterSpacing: -0.3,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.company,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bookmark_border_rounded,
                        color: Color(0xFF4F46E5),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      widget.title.contains('UI/UX')
                          ? Icons.calendar_today_outlined
                          : Icons.work_outline_rounded,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.type,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. Tags Row
  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.tags.map((tag) {
            Color bg;
            Color fg;
            final t = tag.toLowerCase();
            if (t.contains('figma') || t.contains('front')) {
              bg = const Color(0xFFF3E8FF);
              fg = const Color(0xFF9333EA);
            } else if (t.contains('design system') || t.contains('react')) {
              bg = const Color(0xFFE0F2FE);
              fg = const Color(0xFF0284C7);
            } else if (t.contains('research') || t.contains('tail')) {
              bg = const Color(0xFFDCFCE7);
              fg = const Color(0xFF15803D);
            } else {
              bg = const Color(0xFFF3F4F6);
              fg = const Color(0xFF4B5563);
            }
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildTagPill(tag, bg, fg),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTagPill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  // 3. Stats Row
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Applicants', '120+')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Stipend', widget.stipend)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Views', '1.2k')),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Tabs Header
  Widget _buildTabsHeader() {
    final tabs = ['ABOUT', 'REQUIREMENTS', 'PERKS', 'SIMILAR'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (i) {
                final isSelected = _selectedTab == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = i),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Column(
                      children: [
                        Text(
                          tabs[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF6B7280),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 2.5,
                          width: 40,
                          color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }

  // 5. About Section
  Widget _buildAboutSection() {
    final aboutText = widget.about ??
        (widget.title.contains('UI/UX')
            ? 'Join our design team and create delightful, accessible, and meaningful experiences for millions of users. You’ll collaborate with cross-functional teams to tackle real-world problems through user-centered design.'
            : 'Join our world-class engineering team and build fast, accessible, and beautiful user experiences. You\'ll work on real-world projects, collaborate with designers and engineers, and make an impact used by millions of people around the world.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this Internship',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            aboutText,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Perks Section
  Widget _buildPerksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perks & Benefits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.medical_services_outlined, 'Health Benefits')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(Icons.restaurant_outlined, 'Free Gourmet Meals')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.school_outlined, 'Mentorship')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(Icons.fitness_center_outlined, 'Gym Membership')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerkTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF0284C7), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Requirements Section
  Widget _buildRequirementsSection() {
    final reqs = widget.requirements ??
        (widget.title.contains('UI/UX')
            ? [
                'Proficiency in Figma, Adobe XD, or Sketch.',
                'Strong understanding of UI/UX principles and design systems.',
                'Experience with user research and usability testing.',
                'A strong portfolio showcasing end-to-end design projects.',
              ]
            : [
                'Strong portfolio demonstrating frontend projects and user empathy',
                'Proficiency in React, JavaScript, and modern CSS frameworks',
                'Experience with state management libraries (e.g., Redux, Zustand, Context API)',
                'Understanding of responsive design and cross-browser compatibility',
              ]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requirements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Column(
              children: reqs.map((req) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        req,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 8. Similar Internships Section
  Widget _buildSimilarInternshipsSection() {
    final isUiUx = widget.title.contains('UI/UX');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Similar Internships',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSimilarCard(
                  icon: isUiUx ? Icons.grid_view_rounded : Icons.all_inclusive_rounded,
                  title: isUiUx ? 'Product Design Intern' : 'UI Engineer Intern',
                  company: isUiUx ? 'Microsoft' : 'Meta • Full-time',
                  salary: '₹45k/mo',
                  badge: isUiUx ? 'HOT' : '95%',
                  accent: isUiUx ? const Color(0xFF9333EA) : const Color(0xFF0284C7),
                  isHot: isUiUx,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSimilarCard(
                  icon: isUiUx ? Icons.cloud_outlined : Icons.note_alt_outlined,
                  title: 'UX Research Intern',
                  company: isUiUx ? 'Amazon' : 'Notion • Part-time',
                  salary: '₹40k/mo',
                  badge: isUiUx ? '95% Match' : '93%',
                  accent: const Color(0xFF0284C7),
                  isHot: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard({
    required IconData icon,
    required String title,
    required String company,
    required String salary,
    required String badge,
    required Color accent,
    bool isHot = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isHot ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isHot ? const Color(0xFFEF4444) : const Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            company,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            salary,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  // 9. Bottom Action Bar
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ApplicationDetailsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Apply Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  int _selectedTab = 0; // 0 = About, 1 = Requirements, 2 = Perks

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBannerWithHeaderCard(context),
                    const SizedBox(height: 16),
                    _buildTags(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildTabsHeader(),
                    const SizedBox(height: 20),
                    _buildAboutSection(),
                    const SizedBox(height: 24),
                    _buildPerksSection(),
                    const SizedBox(height: 24),
                    _buildRequirementsSection(),
                    const SizedBox(height: 24),
                    _buildSimilarJobsSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // 1. Top Banner + Header Card overlapping
  Widget _buildTopBannerWithHeaderCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Office Banner Image
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Navigation controls
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        // Floating Card
        Padding(
          padding: const EdgeInsets.only(top: 140, left: 20, right: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF3F0FF), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Senior Software',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                              letterSpacing: -0.4,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'Engineer',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                              letterSpacing: -0.4,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.window_rounded,
                        color: Color(0xFF6B7280),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Mountain View, CA (Hybrid)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 15,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '24 - 32 LPA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. Tags Row
  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTagPill('Full-time', const Color(0xFFE0F2FE), const Color(0xFF0284C7)),
            const SizedBox(width: 8),
            _buildTagPill('Hybrid', const Color(0xFFE0F2FE), const Color(0xFF0284C7)),
            const SizedBox(width: 8),
            _buildTagPill('Senior Level', const Color(0xFFE0F2FE), const Color(0xFF0284C7)),
          ],
        ),
      ),
    );
  }

  Widget _buildTagPill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // 3. Stats Row
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Applied', '450+')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Size', '10k+')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Views', '5.2k')),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // 4. Tabs Header
  Widget _buildTabsHeader() {
    final tabs = ['About', 'Requirements', 'Perks'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: List.generate(tabs.length, (i) {
              final isSelected = _selectedTab == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    children: [
                      Text(
                        tabs[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2.5,
                        width: 40,
                        color: isSelected ? AppColors.primary : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }

  // 5. About Section
  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'About this role',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "As a Senior Software Engineer at Google, you will lead the design and development of innovative products that touch the lives of millions. You'll work within our core engineering teams to build scalable, high-performance web applications using modern technologies like React and Node.js. We value creative problem solvers who are passionate about clean code and mentorship.",
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Perks Section
  Widget _buildPerksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perks & Benefits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.medical_services_outlined, 'Health Benefits')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(Icons.restaurant_outlined, 'Free Gourmet Food')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.savings_outlined, '401k Matching')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(Icons.fitness_center_outlined, 'On-site Gym')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerkTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0284C7), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Requirements Section
  Widget _buildRequirementsSection() {
    const reqs = [
      'Mastery in React, Node.js, and TypeScript with 5+ years of production experience.',
      'Proven track record of architecting scalable microservices architectures.',
      'Strong leadership skills and experience mentoring junior developers.',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requirements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          ...reqs.map((req) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF0284C7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        req,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // 8. Similar Jobs Section
  Widget _buildSimilarJobsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Similar Jobs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'SEE ALL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSimilarCard(
                  icon: Icons.cloud_outlined,
                  title: 'UX Research Intern',
                  company: 'Velocity AI',
                  salary: '\$4k/mo',
                  badge: 'HOT',
                  badgeColor: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSimilarCard(
                  icon: Icons.code_rounded,
                  title: 'Frontend Intern',
                  company: 'CloudStream',
                  salary: '\$6k/mo',
                  badge: 'NEW',
                  badgeColor: const Color(0xFF0369A1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard({
    required IconData icon,
    required String title,
    required String company,
    required String salary,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FF), width: 1.2),
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
                  color: const Color(0xFFEDE9FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            company,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                salary,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              if (badge.isNotEmpty)
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 9. Bottom Action Bar
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBAE6FD), width: 1.2),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ApplicationDetailsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Apply Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

