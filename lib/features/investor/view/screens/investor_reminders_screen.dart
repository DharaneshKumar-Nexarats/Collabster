import 'package:flutter/material.dart';
import '../../../../core/theme/investor_colors.dart';

class DealReminder {
  DealReminder({
    required this.id,
    required this.title,
    required this.priority,
    required this.dueDate,
    required this.startup,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String priority; // Normal, Important, High Urgent
  final String dueDate;
  final String startup;
  bool isCompleted;
}

/// Reminders Screen — view, manage & complete deal reminders
class InvestorRemindersScreen extends StatefulWidget {
  const InvestorRemindersScreen({super.key});

  @override
  State<InvestorRemindersScreen> createState() => _InvestorRemindersScreenState();
}

class _InvestorRemindersScreenState extends State<InvestorRemindersScreen> {
  String _filter = 'All';

  final List<DealReminder> _reminders = [
    DealReminder(
      id: 'r1',
      title: 'Review Series A Term Sheet for Nova Robotics',
      priority: 'High Urgent',
      dueDate: 'Today at 5:00 PM',
      startup: 'Nova Robotics',
    ),
    DealReminder(
      id: 'r2',
      title: 'Follow up on FinEdge Cap Table Diligence Audit',
      priority: 'Important',
      dueDate: 'Tomorrow at 10:00 AM',
      startup: 'FinEdge Tech',
    ),
    DealReminder(
      id: 'r3',
      title: 'Send LP Co-Investment Allocation Sheet',
      priority: 'Normal',
      dueDate: 'Aug 30, 2026',
      startup: 'Apex Syndicate',
    ),
    DealReminder(
      id: 'r4',
      title: 'Schedule Founder Reference Call with Ex-Stripe VP',
      priority: 'Important',
      dueDate: 'Sep 02, 2026',
      startup: 'QuantumPay',
    ),
  ];

  List<DealReminder> get _filtered {
    if (_filter == 'Urgent') {
      return _reminders.where((r) => r.priority == 'High Urgent').toList();
    }
    if (_filter == 'Completed') {
      return _reminders.where((r) => r.isCompleted).toList();
    }
    return _reminders;
  }

  Color _priorityColor(String prio) {
    if (prio == 'High Urgent') return const Color(0xFFEF4444);
    if (prio == 'Important') return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 21),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deal Reminders',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Track term sheet deadlines & diligence alerts',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_reminders.where((r) => !r.isCompleted).length} Pending',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Filter Pills
                      Row(
                        children: ['All', 'Urgent', 'Completed'].map((f) {
                          final isSel = _filter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _filter = f),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSel ? Colors.white : Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    color: isSel ? InvestorColors.ink : Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (_filtered.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 48, color: InvestorColors.green),
                        SizedBox(height: 12),
                        Text(
                          'No reminders found',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: InvestorColors.ink),
                        ),
                        SizedBox(height: 4),
                        Text('All deal follow-ups and term sheet deadlines are clear.', style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted)),
                      ],
                    ),
                  )
                else
                  ..._filtered.map((rem) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: InvestorColors.border),
                          boxShadow: const [
                            BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: rem.isCompleted,
                              activeColor: InvestorColors.goldDeep,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              onChanged: (val) {
                                setState(() {
                                  rem.isCompleted = val ?? false;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _priorityColor(rem.priority).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          rem.priority,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: _priorityColor(rem.priority),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        rem.startup,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: InvestorColors.textMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    rem.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: rem.isCompleted ? Colors.grey.shade400 : InvestorColors.ink,
                                      decoration: rem.isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 14, color: InvestorColors.goldDeep),
                                      const SizedBox(width: 4),
                                      Text(
                                        rem.dueDate,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: InvestorColors.goldDeep),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
