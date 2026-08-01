import 'package:flutter/material.dart';
import '../../model/startup_models.dart';

class StartupMilestonesScreen extends StatefulWidget {
  const StartupMilestonesScreen({super.key});

  @override
  State<StartupMilestonesScreen> createState() => _StartupMilestonesScreenState();
}

class _StartupMilestonesScreenState extends State<StartupMilestonesScreen> {
  final List<Milestone> _milestones = [
    Milestone(title: 'Idea Created', date: 'Jan 15, 2023 • Initial ideation phase', completed: true, active: false),
    Milestone(title: 'Team Assembled', date: 'Feb 25, 2023 • Core engineering team hired', completed: true, active: false),
    Milestone(title: 'Seed Funding Secured', date: 'May 10, 2023 • First \$50K from early VC', completed: true, active: false),
    Milestone(title: 'Beta Phase Started', date: 'Sep 4, 2023 • Feature complete, stability testing', completed: true, active: false),
    Milestone(title: 'MVP Launched', date: 'In Progress - Feature complete, stability testing', completed: false, active: true),
    Milestone(title: 'First 1,000 Customers', date: 'Expected: June 2024', completed: false, active: false),
    Milestone(title: 'Series A Funding', date: 'Expected: June 2024', completed: false, active: false),
  ];

  @override
  Widget build(BuildContext context) {
    final completed = _milestones.where((m) => m.completed).length;
    final total = _milestones.length;
    final progress = completed / total;

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
                left: 20, right: 20, bottom: 24,
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
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Milestones', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('YOUR STARTUP JOURNEY', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        const Text("You're making great progress!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$completed of $total milestones completed', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            Text('${(progress * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _statChip('$completed', 'COMPLETED'),
                            const SizedBox(width: 10),
                            _statChip('${_milestones.where((m) => m.active).length}', 'IN PROGRESS'),
                            const SizedBox(width: 10),
                            _statChip('${_milestones.where((m) => !m.completed && !m.active).length}', 'UPCOMING'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: const Text('ROADMAP TIMELINE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF9CA3AF), letterSpacing: 1.2)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: MilestoneItem(milestone: _milestones[index], isLast: index == _milestones.length - 1),
              ),
              childCount: _milestones.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddMilestoneSheet(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Milestone', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  void _showAddMilestoneSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999)))),
              const SizedBox(height: 18),
              const Text('Add Milestone', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 14),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Milestone title',
                  filled: true, fillColor: const Color(0xFFF6F3FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (titleCtrl.text.isNotEmpty) {
                      setState(() {
                        _milestones.add(Milestone(
                          title: titleCtrl.text,
                          date: 'Expected: TBD',
                          completed: false,
                          active: false,
                        ));
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: const Color(0xFF5B21B6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MilestoneItem extends StatelessWidget {
  const MilestoneItem({required this.milestone, required this.isLast});
  final Milestone milestone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = milestone.completed
        ? const Color(0xFF059669)
        : milestone.active
            ? const Color(0xFF5B21B6)
            : const Color(0xFFD1D5DB);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              child: Icon(
                milestone.completed ? Icons.check : (milestone.active ? Icons.radio_button_checked : Icons.circle_outlined),
                color: Colors.white,
                size: 14,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 60, color: const Color(0xFFE5E7EB)),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: milestone.completed || milestone.active ? const Color(0xFF12233D) : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    if (milestone.completed)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(999)),
                        child: const Text('DONE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF059669), letterSpacing: 0.6)),
                      ),
                    if (milestone.active)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(999)),
                        child: const Text('IN PROGRESS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF5B21B6), letterSpacing: 0.6)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: milestone.completed || milestone.active ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

