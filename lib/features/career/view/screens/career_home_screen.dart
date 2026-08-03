import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'career_dashboard_screen.dart';
import 'internships_screen.dart';
import 'jobs_screen.dart';
import 'freelance_screen.dart';
import 'resume_screen.dart';
import 'mock_interviews_screen.dart';
import 'saved_jobs_screen.dart';
import 'applied_applications_screen.dart';
import 'notifications_screen.dart';





// ---------------------------------------------------------------------------
// CareerHomeScreen — Shell with bottom navigation.
// Opens with Dashboard (index 0) by default after registration.
// ---------------------------------------------------------------------------

class CareerHomeScreen extends StatefulWidget {
  const CareerHomeScreen({super.key});

  @override
  State<CareerHomeScreen> createState() => _CareerHomeScreenState();
}

class _CareerHomeScreenState extends State<CareerHomeScreen> {
  // index 0 = Dashboard (opens first after Career registration)
  int _selectedIndex = 0;
  bool _showInternships = false;
  bool _showJobs = false;
  bool _showFreelance = false;
  bool _showResume = false;
  bool _showMocks = false;

  final List<String> _trendingSkills = [
    'System Design',
    'LLM Engineering',
    'Next.js',
    'Rust',
    'AWS Lambda',
    'Tailwind CSS',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _showMocks
              ? MockInterviewsScreen(
                  onBack: () => setState(() => _showMocks = false),
                )
              : _showResume
                  ? ResumeScreen(
                      onBack: () => setState(() => _showResume = false),
                    )
                  : _showFreelance
                      ? FreelanceScreen(
                          onBack: () => setState(() => _showFreelance = false),
                        )
                      : _showJobs
                          ? JobsScreen(
                              onBack: () => setState(() => _showJobs = false),
                            )
                          : _showInternships
                              ? InternshipsScreen(
                                  onBack: () => setState(() => _showInternships = false),
                                )
                              : CareerDashboardScreen(
                                  onResumeTap: () => setState(() => _showResume = true),
                                  onFreelanceTap: () => setState(() => _showFreelance = true),
                                  onJobsTap: () => setState(() => _showJobs = true),
                                  onInternshipsTap: () =>
                                      setState(() => _showInternships = true),
                                  onMocksTap: () =>
                                      setState(() => _showMocks = true),
                                ), // 0 – Dashboard
          _buildExploreTab(),            // 1 – Explore
          _buildPlaceholderTab('Post a Job / New Action'), // 2 – Centre +
          AppliedApplicationsScreen(
            onBack: () => setState(() => _selectedIndex = 0),
          ),              // 3 – Applied
          SavedJobsScreen(
            onBack: () => setState(() => _selectedIndex = 0),
          ),              // 4 – Saved
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ---------------------------------------------------------------------------
  // EXPLORE TAB
  // ---------------------------------------------------------------------------
  Widget _buildExploreTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Header (no back arrow — this is a bottom nav tab) ───────
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: AppColors.primary, size: 26),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Where would you like to grow today, Alex?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C2C3E),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),

          // ── Search Bar (overflow-safe — no TextField inside Row) ─────────
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFDCDAF4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search roles, skills, or companies . . .',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildFeatureCard(
            icon: Icons.work_outline,
            title: 'Find Your Role',
            description:
                'Explore AI-curated job feeds tailored to your unique expertise and career goals.',
            actionText: 'Explore Jobs >',
            onTap: () {},
          ),
          const SizedBox(height: 16),

          _buildFeatureCard(
            icon: Icons.psychology_outlined,
            title: 'Practice & Interview',
            description:
                'Sharpen your skills with AI-powered mock interviews and real-time coding challenges.',
            actionText: 'Start Session >',
            onTap: () {},
          ),
          const SizedBox(height: 16),

          _buildFeatureCard(
            icon: Icons.show_chart_rounded,
            title: 'Track Progress',
            description:
                'Monitor your application pipeline and see exactly where you stand in the process.',
            actionText: 'View Pipeline >',
            onTap: () {},
          ),
          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jobs Picked For You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildExplorJobCard(
            companyLogo: Icons.layers_outlined,
            title: 'Senior Product Designer',
            company: 'Flow State',
            location: 'Remote, US',
            salary: '\$160k - \$210k',
            isActivelyHiring: true,
          ),
          const SizedBox(height: 16),

          _buildExplorJobCard(
            companyLogo: Icons.auto_awesome_outlined,
            title: 'Staff ML Engineer',
            company: 'Nexus AI',
            location: 'Palo Alto, CA',
            salary: '\$220k - \$280k',
            isActivelyHiring: true,
          ),
          const SizedBox(height: 24),

          _buildTrendingSkillsCard(),
          const SizedBox(height: 24),

          _buildSalaryAnalyticsCard(),
          const SizedBox(height: 24),

          _buildPremiumBanner(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FEATURE CARDS
  // ---------------------------------------------------------------------------
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6D0FE), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECE9FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style:
                TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EXPLORE TAB – JOB CARD  (overflow-safe)
  // ---------------------------------------------------------------------------
  Widget _buildExplorJobCard({
    required IconData companyLogo,
    required String title,
    required String company,
    required String location,
    required String salary,
    required bool isActivelyHiring,
  }) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E0FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: logo + details ────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company logo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(companyLogo, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),

              // Job details – Expanded so it never overflows
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + badge on same row, badge wraps below if needed
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title is Flexible so badge never gets pushed out
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ),
                        ),
                        if (isActivelyHiring) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FADF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '• HIRING',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF039855),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Company • Location row – each Text is Flexible
                    Row(
                      children: [
                        const Icon(Icons.business,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            company,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Salary
                    Text(
                      '💵  $salary',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333344),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Bottom row: Save + Apply Now ───────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(0, 40),
                    side: const BorderSide(color: Color(0xFFC7C3FA)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save',
                      style:
                          TextStyle(fontSize: 14, color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(0, 40),
                    backgroundColor: const Color(0xFF4F46E5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Apply Now',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // ---------------------------------------------------------------------------
  // TRENDING SKILLS CARD
  // ---------------------------------------------------------------------------
  Widget _buildTrendingSkillsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2DCFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Skills',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _trendingSkills.map((skill) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDED6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3F34B2),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SALARY ANALYTICS CARD
  // ---------------------------------------------------------------------------
  Widget _buildSalaryAnalyticsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2DCFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Salary Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Market value benchmarks for Senior Design roles in your area.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Stack(
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 100),
                  painter: _SalaryGraphPainter(),
                ),
                Positioned(
                  right: 40,
                  top: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '\$185k',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E202B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Check Market Value',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PREMIUM BANNER
  // ---------------------------------------------------------------------------
  Widget _buildPremiumBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF232538), Color(0xFF1D1B2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'PREMIUM',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Unlock AI Resume Boost',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get 50% more matches with our deep-learning profile optimizer.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade300,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Go Pro Now',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.auto_awesome,
                    size: 16, color: Colors.amberAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION BAR
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.explore_outlined, 'Explore'),
              _buildCenterAddButton(),
              _buildNavItem(3, Icons.work_outline, 'Applied'),
              _buildNavItem(4, Icons.bookmark_border, 'Saved'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
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
              color:
                  isSelected ? AppColors.primary : Colors.grey.shade500,
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

  Widget _buildCenterAddButton() {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = 2),
      child: Container(
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
        child:
            const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PLACEHOLDER TAB
  // ---------------------------------------------------------------------------
  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.dashboard_outlined,
              size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SALARY GRAPH PAINTER
// ---------------------------------------------------------------------------
class _SalaryGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF6B4EFF).withOpacity(0.25),
          const Color(0xFF6B4EFF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFF6B4EFF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.75);
    path.cubicTo(
      size.width * 0.2, size.height * 0.85,
      size.width * 0.35, size.height * 0.4,
      size.width * 0.5, size.height * 0.65,
    );
    path.cubicTo(
      size.width * 0.65, size.height * 0.9,
      size.width * 0.8, size.height * 0.2,
      size.width, size.height * 0.7,
    );

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
