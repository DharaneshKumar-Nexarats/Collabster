import 'package:flutter/material.dart';

import '../../model/startup_models.dart';

class FundraisingDashboardScreen extends StatefulWidget {
  const FundraisingDashboardScreen({super.key, required this.startupName});
  final String startupName;

  @override
  State<FundraisingDashboardScreen> createState() => _FundraisingDashboardScreenState();
}

class _FundraisingDashboardScreenState extends State<FundraisingDashboardScreen> {
  double _raisedAmount = 1.2;
  final double _targetAmount = 2.0;

  final List<FundraisingInvestor> _activeInvestors = const [
    FundraisingInvestor(name: 'Horizon Ventures', fund: 'Series A', amount: '\$350K', meetingIn: 'Meeting Tomorrow', initials: 'HV', color: Color(0xFF4F46E5)),
    FundraisingInvestor(name: 'NorthStar Ventures', fund: 'Pre-seed', amount: '\$400K', meetingIn: 'Not Engaged', initials: 'NV', color: Color(0xFF0D9488)),
    FundraisingInvestor(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', meetingIn: '2 weeks ago', initials: 'SF', color: Color(0xFFF59E0B)),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = _raisedAmount / _targetAmount;

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
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Fundraising', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CURRENT ROUND', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                                SizedBox(height: 4),
                                Text('Series A', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('TARGET', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                                SizedBox(height: 4),
                                Text('\$2,000,000', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$${_raisedAmount.toStringAsFixed(1)}M Raised', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                            Text('${(progress * 100).round()}% of target', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: _fundStat('12', 'MEETINGS')),
                            Expanded(child: _fundStat('4', 'INTROS')),
                            Expanded(child: _fundStat('150', 'REACH')),
                            Expanded(child: _fundStat('85', 'REPLIES')),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Needs Your Attention', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 12),
                  _taskCard(Icons.event_outlined, 'Investor Meeting Tomorrow', 'Horizon Ventures – 10:00 AM', isUrgent: true),
                  const SizedBox(height: 10),
                  _taskCard(Icons.description_outlined, 'Update Pitch Deck', 'Slides are 2 months outdated.', isUrgent: false),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Active Opportunities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: Color(0xFF5B21B6)))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(_activeInvestors.length, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _InvestorOpportunityCard(investor: _activeInvestors[i]),
                  )),
                  const SizedBox(height: 8),
                  const Text('Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 10),
                  _docItem(Icons.picture_as_pdf_outlined, 'Pitch Deck v3.pdf', '2.4 MB', '+ Add More'),
                  const SizedBox(height: 8),
                  _docItem(Icons.calculate_outlined, 'Financial Projections.pdf', '1.6 MB', '+ Add More'),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddInvestorSheet(context),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Add New Investor', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: const Color(0xFF5B21B6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fundStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.6)),
      ],
    );
  }

  Widget _taskCard(IconData icon, String title, String sub, {required bool isUrgent}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUrgent ? Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)) : null,
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFFFEF3C7) : const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isUrgent ? const Color(0xFFF59E0B) : const Color(0xFF5B21B6), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
                Text(sub, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 34),
              side: BorderSide(color: isUrgent ? const Color(0xFFF59E0B) : const Color(0xFF5B21B6)),
              foregroundColor: isUrgent ? const Color(0xFFF59E0B) : const Color(0xFF5B21B6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: const Text('Act', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _docItem(IconData icon, String name, String size, String action) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5B21B6), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
                Text(size, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: Text(action, style: const TextStyle(color: Color(0xFF5B21B6), fontSize: 12, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _showAddInvestorSheet(BuildContext context) {
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
              const Text('Add New Investor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 14),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Investor Name / Fund',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true, fillColor: const Color(0xFFF6F3FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { Navigator.pop(ctx); setState(() { _raisedAmount = (_raisedAmount + 0.1).clamp(0, 2.0); }); },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: const Color(0xFF5B21B6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Add Investor', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvestorOpportunityCard extends StatelessWidget {
  const _InvestorOpportunityCard({required this.investor});
  final FundraisingInvestor investor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: investor.color.withValues(alpha: 0.12),
            child: Text(investor.initials, style: TextStyle(color: investor.color, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(investor.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                Text('${investor.fund} · ${investor.amount}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text(investor.meetingIn, style: TextStyle(fontSize: 11, color: investor.color, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(0, 36),
              foregroundColor: const Color(0xFF5B21B6),
              side: const BorderSide(color: Color(0xFF5B21B6)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: const Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
