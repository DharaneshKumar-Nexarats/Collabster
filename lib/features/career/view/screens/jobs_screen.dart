import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/career_search_bar.dart';
import 'internships_screen.dart';
import 'job_detail_screen.dart';


class JobsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const JobsScreen({super.key, this.onBack});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All Roles', 'Remote', 'Paid', 'Hybrid'];
  final TextEditingController _searchController = TextEditingController();

  static const _jobs = [
    _JobItem(
      logo: Icons.code_rounded,
      title: 'Senior Software Engineer',
      company: 'Google',
      location: 'Mountain View (Hybrid)',
      salaryTag: '24 - 32 LPA',
      tags: ['React', 'Node.js', 'Go'],
      timeAgo: '2 hours ago',
      showNew: true,
    ),
    _JobItem(
      logo: Icons.design_services_outlined,
      title: 'Product Designer',
      company: 'Stripe',
      location: 'Remote',
      salaryTag: '18 - 25 LPA',
      tags: ['Figma', 'Prototyping', 'Design Systems'],
      timeAgo: '5 hours ago',
      showNew: false,
    ),
    _JobItem(
      logo: Icons.analytics_outlined,
      title: 'Data Analyst',
      company: 'Microsoft',
      location: 'Bangalore (On-site)',
      salaryTag: '15 - 22 LPA',
      tags: ['Python', 'SQL', 'Tableau'],
      timeAgo: '1 day ago',
      showNew: false,
    ),
  ];

  List<_JobItem> get _filteredJobs {
    final query = _searchController.text.trim().toLowerCase();
    final filter = _filters[_selectedFilter].toLowerCase();

    return _jobs.where((job) {
      // Filter by chip category
      if (filter == 'remote' && !job.location.toLowerCase().contains('remote')) {
        return false;
      }
      if (filter == 'hybrid' && !job.location.toLowerCase().contains('hybrid')) {
        return false;
      }
      if (filter == 'paid' && !job.salaryTag.isNotEmpty) {
        return false;
      }

      // Filter by search query
      if (query.isEmpty) return true;
      final titleMatch = job.title.toLowerCase().contains(query);
      final companyMatch = job.company.toLowerCase().contains(query);
      final locationMatch = job.location.toLowerCase().contains(query);
      final tagMatch = job.tags.any((t) => t.toLowerCase().contains(query));

      return titleMatch || companyMatch || locationMatch || tagMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation & Top Icons Row
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Discover Jobs',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Find opportunities tailored to your career  goals.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 18),

          // Search bar
          CareerSearchBar(
            controller: _searchController,
            hintText: 'Search jobs, skills, or companies...',
            hasActiveFilter: _selectedFilter != 0,
            onChanged: (value) => setState(() {}),
            onFilterTap: () {
              setState(() {
                _selectedFilter = (_selectedFilter + 1) % _filters.length;
              });
            },
          ),
          const SizedBox(height: 16),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (i) {
                final selected = _selectedFilter == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: selected ? AppColors.primary : const Color(0xFFBAE6FD),
                        width: 1.3,
                      ),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : const Color(0xFF0369A1),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final filtered = _filteredJobs;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Jobs Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _searchController.text.isNotEmpty || _selectedFilter != 0
                    ? 'Search Results (${filtered.length})'
                    : 'Popular Jobs',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _selectedFilter = 0;
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Job Cards or Empty state
          if (filtered.isNotEmpty)
            ...filtered.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildJobCard(item),
                ))
          else
            _buildEmptyState(),


          const SizedBox(height: 16),

          // Popular Companies Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Companies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Showing all companies...')),
                  );
                },
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Company Cards Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCompanyCard(
                  name: 'Synthetix AI',
                  category: 'Artificial Intelligence',
                  openPositions: '42 Open Positions',
                  rating: '4.8',
                ),
                const SizedBox(width: 14),
                _buildCompanyCard(
                  name: 'Creative Design',
                  category: 'UI/UX Design',
                  openPositions: '18 Open Positions',
                  rating: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(_JobItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(item.logo, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        if (item.showNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0369A1),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.company} • ${item.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.salaryTag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0369A1),
                  ),
                ),
              ),
              ...item.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
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
                  )),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                item.timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bookmark_border_rounded, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (item.title == 'Senior Software Engineer') {
                    Navigator.push(
                      context,
                      SmoothRightToLeftPageRoute(
                        builder: (context) => const JobDetailsScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(80, 38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard({
    required String name,
    required String category,
    required String openPositions,
    required String rating,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            category,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                openPositions,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              if (rating.isNotEmpty) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                Text(
                  rating,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading all available jobs...')),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text(
              'View Jobs',
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

  Widget _buildEmptyState() {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded, color: Color(0xFF0284C7), size: 28),
          ),
          const SizedBox(height: 12),
          const Text(
            'No matching jobs found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try adjusting your search query or clear filters.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _JobItem {
  final IconData logo;
  final String title, company, location, salaryTag, timeAgo;
  final List<String> tags;
  final bool showNew;
  const _JobItem({
    required this.logo,
    required this.title,
    required this.company,
    required this.location,
    required this.salaryTag,
    required this.tags,
    required this.timeAgo,
    required this.showNew,
  });
}
