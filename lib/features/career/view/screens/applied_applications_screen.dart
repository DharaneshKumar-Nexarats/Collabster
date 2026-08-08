import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'submission_details_screen.dart';


class AppliedApplicationsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const AppliedApplicationsScreen({super.key, this.onBack});

  @override
  State<AppliedApplicationsScreen> createState() => _AppliedApplicationsScreenState();
}

class _AppliedApplicationsScreenState extends State<AppliedApplicationsScreen> {
  int _selectedTab = 0; // 0 = Active Applications, 1 = Archived / History

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Applied',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Metric Row Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard('Total Applied', '12'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMetricCard('In Review', '5'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMetricCard('Interviews', '3'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Toggle Switcher capsule
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTab = 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 0
                                        ? const Color(0xFF0284C7)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Active Applications',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTab == 0
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTab = 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 1
                                        ? const Color(0xFF0284C7)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Archived / History',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTab == 1
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Applications List
                      _buildApplicationCard(
                        logoUrl: 'https://img.icons8.com/color/48/adobe-illustrator.png',
                        title: 'Senior Product Designer',
                        company: 'Nexus Systems',
                        statusLabel: 'APPLICATION RECEIVED',
                        statusColor: const Color(0xFF10B981),
                        statusBgColor: const Color(0xFFE6FBF3),
                        isActive: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubmissionDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildApplicationCard(
                        logoUrl: 'https://img.icons8.com/color/48/figma--v1.png',
                        title: 'Frontend Engineer',
                        company: 'CloudStrate',
                        statusLabel: 'UNDER REVIEW',
                        statusColor: const Color(0xFF0284C7),
                        statusBgColor: const Color(0xFFE0F2FE),
                        isActive: true,
                      ),
                      const SizedBox(height: 16),

                      _buildApplicationCard(
                        logoUrl: 'https://img.icons8.com/color/48/microsoft.png',
                        title: 'UX Researcher',
                        company: 'Aether Analytics',
                        statusLabel: 'INTERVIEW SCHEDULED',
                        statusColor: const Color(0xFF0284C7),
                        statusBgColor: const Color(0xFFE0F2FE),
                        isActive: true,
                      ),
                      const SizedBox(height: 16),

                      _buildApplicationCard(
                        logoUrl: 'https://img.icons8.com/color/48/google-logo.png',
                        title: 'Machine Learning Engineer',
                        company: 'Vortex AI',
                        statusLabel: 'REJECTED',
                        statusColor: Colors.grey.shade500,
                        statusBgColor: const Color(0xFFF1F5F9),
                        isActive: false,
                      ),
                      const SizedBox(height: 24),
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

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0284C7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard({
    required String logoUrl,
    required String title,
    required String company,
    required String statusLabel,
    required Color statusColor,
    required Color statusBgColor,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo, title and chat row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(logoUrl, width: 36, height: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isActive ? const Color(0xFF1E293B) : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      company,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: isActive ? const Color(0xFF0284C7) : Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 3.5,
                  backgroundColor: statusColor,
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Two buttons
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: isActive ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Track Status',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton(
              onPressed: isActive ? () {} : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isActive ? const Color(0xFF0284C7) : Colors.grey.shade200,
                  width: 1.2,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'View Submission',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? const Color(0xFF0284C7) : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    ),);
  }
}
