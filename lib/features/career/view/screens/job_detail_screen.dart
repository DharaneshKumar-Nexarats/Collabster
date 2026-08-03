import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'application_details_screen.dart';


class InternshipDetailsScreen extends StatefulWidget {
  const InternshipDetailsScreen({super.key});

  @override
  State<InternshipDetailsScreen> createState() => _InternshipDetailsScreenState();
}

typedef JobDetailScreen = InternshipDetailsScreen;

class _InternshipDetailsScreenState extends State<InternshipDetailsScreen> {
  int _selectedTab = 0; // 0 = ABOUT, 1 = REQUIREMENTS, 2 = PERKS

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
              // Share Button
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
              // Bell Button
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary,
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
                            'Product Design',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                              letterSpacing: -0.4,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'Intern',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                              letterSpacing: -0.4,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Nexus Systems',
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
                        color: const Color(0xFFEDE9FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: AppColors.primary,
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
                      'SAN FRANCISCO, CA',
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
                      '\$5,000 - \$7,500/MO',
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
            _buildTagPill('3 MONTHS', const Color(0xFFF3E8FF), const Color(0xFF9333EA)),
            const SizedBox(width: 8),
            _buildTagPill('REMOTE', const Color(0xFFE0F2FE), const Color(0xFF0284C7)),
            const SizedBox(width: 8),
            _buildTagPill('STIPEND', const Color(0xFFF3E8FF), const Color(0xFF9333EA)),
            const SizedBox(width: 8),
            _buildTagPill('FULL-TIME', const Color(0xFFF3F4F6), const Color(0xFF4B5563)),
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
          Expanded(child: _buildStatCard('Applied', '120+')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Size', '500+')),
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
        color: const Color(0xFFFAFAFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE9FF), width: 1.2),
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
    final tabs = ['ABOUT', 'REQUIREMENTS', 'PERKS'];
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
            'About this Internship',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Join our world-class design team at Nexus Systems to help build the future of collaborative productivity. As a Product Design Intern, you will work directly with senior designers and engineers to conceptualize, prototype, and ship features used by millions of developers worldwide. We value creativity, pixel perfection, and a user-first mindset.',
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
          Icon(icon, color: const Color(0xFF0D9488), size: 20),
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
      'Strong portfolio demonstrating product design principles and user empathy.',
      'Proficiency in Figma, Prototyping tools, and design systems.',
      'Experience with user research and usability testing methodologies.',
      'Currently enrolled in or recently graduated from a relevant degree.',
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
                      color: Color(0xFF7C3AED),
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

  // 8. Similar Internships Section
  Widget _buildSimilarInternshipsSection() {
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
                'VIEW ALL',
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
                  icon: Icons.design_services_outlined,
                  title: 'UX Research Intern',
                  company: 'Velocity AI',
                  salary: '\$4k/mo',
                  badge: 'Remote',
                  showHot: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSimilarCard(
                  icon: Icons.cloud_outlined,
                  title: 'Frontend Intern',
                  company: 'CloudStream',
                  salary: '\$6k/mo',
                  badge: '',
                  showHot: false,
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
    required bool showHot,
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
              if (showHot)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
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
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
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
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD8D2FF), width: 1.2),
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
                  colors: [Color(0xFF7C3AED), Color(0xFF5B4EFF)],
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
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary,
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
            _buildTagPill('Full-time', const Color(0xFFF3E8FF), const Color(0xFF9333EA)),
            const SizedBox(width: 8),
            _buildTagPill('Hybrid', const Color(0xFFE0F2FE), const Color(0xFF0284C7)),
            const SizedBox(width: 8),
            _buildTagPill('Senior Level', const Color(0xFFEEF2FF), const Color(0xFF4F46E5)),
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
        color: const Color(0xFFFAFAFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE9FF), width: 1.2),
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
          Icon(icon, color: const Color(0xFF6B4EFF), size: 20),
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
                      color: Color(0xFF7C3AED),
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
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD8D2FF), width: 1.2),
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
                  colors: [Color(0xFF7C3AED), Color(0xFF5B4EFF)],
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

