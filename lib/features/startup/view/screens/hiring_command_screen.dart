import 'package:flutter/material.dart';

import '../../model/startup_models.dart';

class HiringCommandScreen extends StatefulWidget {
  const HiringCommandScreen({super.key, required this.startupName});
  final String startupName;

  @override
  State<HiringCommandScreen> createState() => _HiringCommandScreenState();
}

class _HiringCommandScreenState extends State<HiringCommandScreen> {
  final List<OpenRole> _roles = const [
    OpenRole(
      title: 'Senior AI Engineer',
      department: 'Core Engine / Engineering',
      applicants: 48,
      shortlisted: 6,
      status: 'HIRING',
      statusColor: Color(0xFF059669),
    ),
    OpenRole(
      title: 'ML Research Lead',
      department: 'R&D / Research',
      applicants: 12,
      shortlisted: 2,
      status: 'HIRING',
      statusColor: Color(0xFF059669),
    ),
    OpenRole(
      title: 'Product Designer',
      department: 'Design / UI-UX',
      applicants: 24,
      shortlisted: 4,
      status: 'PAUSED',
      statusColor: Color(0xFFF59E0B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B21B6), Color(0xFF7C3AED), Color(0xFF4338CA)],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Hiring',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ACTIVE RECRUITING', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('6', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800)),
                                  const SizedBox(width: 4),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 6),
                                    child: Text('Open Roles', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.bolt, color: Colors.amber, size: 28),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _pipelineStat('48', 'APPLIED', const Color(0xFF818CF8))),
                      const SizedBox(width: 10),
                      Expanded(child: _pipelineStat('24', 'SHORTLISTED', const Color(0xFF34D399))),
                      const SizedBox(width: 10),
                      Expanded(child: _pipelineStat('12', 'INTERVIEWS', const Color(0xFFFBBF24))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Open Roles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFE8DBFF), borderRadius: BorderRadius.circular(999)),
                        child: const Text('Full List →', style: TextStyle(color: Color(0xFF5B21B6), fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _RoleCard(role: _roles[index]),
              ),
              childCount: _roles.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Needs Your Attention', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 12),
                  _attentionCard(Icons.people_alt_outlined, 'Review 6 applicants for Senior AI Engineer', 'Shortlist before Friday'),
                  const SizedBox(height: 10),
                  _attentionCard(Icons.schedule_outlined, 'Interview scheduled tomorrow', '10:00 AM – Sarah M.'),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateJobSheet(context),
        backgroundColor: const Color(0xFF5B21B6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create New Job', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _pipelineStat(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.6)),
        ],
      ),
    );
  }

  Widget _attentionCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF5B21B6), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Act', style: TextStyle(color: Color(0xFF5B21B6), fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _showCreateJobSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
              ),
              const SizedBox(height: 18),
              const Text('Create New Job', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 14),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Job Title',
                  prefixIcon: const Icon(Icons.work_outline),
                  filled: true,
                  fillColor: const Color(0xFFF6F3FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('"${titleCtrl.text}" role created!'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Publish Job', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role});
  final OpenRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 14, offset: Offset(0, 6))],
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
                    Text(role.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                    const SizedBox(height: 2),
                    Text(role.department, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: role.statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(role.status, style: TextStyle(color: role.statusColor, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _stat('${role.applicants}', 'Applicants'),
              const SizedBox(width: 20),
              _stat('${role.shortlisted}', 'Shortlisted'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing applicants for ${role.title}'), behavior: SnackBarBehavior.floating),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF5B21B6),
                side: const BorderSide(color: Color(0xFF5B21B6)),
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View Applicants →', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      ],
    );
  }
}
