import 'package:flutter/material.dart';

import '../../model/startup_models.dart';

class InvestorPipelineScreen extends StatefulWidget {
  const InvestorPipelineScreen({super.key});

  @override
  State<InvestorPipelineScreen> createState() => _InvestorPipelineScreenState();
}

class _InvestorPipelineScreenState extends State<InvestorPipelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  int _selectedTab = 0;

  List<InvestorEntry> _discoverInvestors = [
    const InvestorEntry(name: 'Vertex Capital', fund: 'Series A', amount: '\$350K', status: 'Tomorrow', statusColor: Color(0xFF5B21B6), initials: 'VC', color: Color(0xFF4F46E5), contacted: 6, replied: 4),
    const InvestorEntry(name: 'NorthStar Ventures', fund: 'Pre-Seed', amount: '\$400K', status: 'Not Engaged', statusColor: Color(0xFF9CA3AF), initials: 'NV', color: Color(0xFF0D9488), contacted: 4, replied: 2),
    const InvestorEntry(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', status: '2 weeks ago', statusColor: Color(0xFF6B7280), initials: 'SF', color: Color(0xFFF59E0B), contacted: 8, replied: 8),
    const InvestorEntry(name: 'TechWave Fund', fund: 'Series A', amount: '\$500K', status: 'Active', statusColor: Color(0xFF059669), initials: 'TW', color: Color(0xFF2563EB), contacted: 3, replied: 2),
  ];

  List<InvestorEntry> _pipelineInvestors = [
    const InvestorEntry(name: 'Vertex Capital', fund: 'Series A', amount: '\$350K', status: 'Meeting Tomorrow', statusColor: Color(0xFF5B21B6), initials: 'VC', color: Color(0xFF4F46E5), contacted: 6, replied: 4),
    const InvestorEntry(name: 'TechWave Fund', fund: 'Series A', amount: '\$500K', status: 'Active', statusColor: Color(0xFF059669), initials: 'TW', color: Color(0xFF2563EB), contacted: 3, replied: 2),
  ];

  List<InvestorEntry> _savedInvestors = [
    const InvestorEntry(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', status: 'Saved', statusColor: Color(0xFF6B7280), initials: 'SF', color: Color(0xFFF59E0B), contacted: 8, replied: 8),
  ];

  Future<void> _showAddInvestorSheet() async {
    final created = await showModalBottomSheet<InvestorEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddInvestorBottomSheet(),
    );

    if (created != null) {
      setState(() {
        _discoverInvestors.insert(0, created);
        _pipelineInvestors.insert(0, created);
      });
    }
  }

  List<InvestorEntry> get _filteredInvestors {
    final query = _searchController.text.toLowerCase();
    List<InvestorEntry> source;
    switch (_selectedTab) {
      case 1:
        source = _pipelineInvestors;
        break;
      case 2:
        source = _savedInvestors;
        break;
      default:
        source = _discoverInvestors;
    }
    if (query.isEmpty) return source;
    return source.where((i) => i.name.toLowerCase().contains(query) || i.fund.toLowerCase().contains(query)).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddInvestorSheet,
        backgroundColor: const Color(0xFF5B21B6),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Investor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
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
                      const Text('Investors', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      IconButton(
                        onPressed: _showAddInvestorSheet,
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                        tooltip: 'Add Investor',
                      ),
                      Icon(Icons.more_vert, color: Colors.white.withValues(alpha: 0.8)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AVAILABLE ROLES', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('18', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800)),
                            const SizedBox(width: 8),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Text('Active Investors', style: TextStyle(color: Colors.white70, fontSize: 14)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _pipelinePill('Introduction', '6'),
                            _pipelinePill('Meetings', '4'),
                            _pipelinePill('Due Diligence', '2'),
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(color: const Color(0xFF5B21B6), borderRadius: BorderRadius.circular(10)),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6B7280),
                      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      dividerColor: Colors.transparent,
                      tabs: const [Tab(text: 'Discover'), Tab(text: 'Pipeline'), Tab(text: 'Saved Talks')],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search investors...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                      filled: true, fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Priority Follow-ups', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: Color(0xFF5B21B6)))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _priorityCard('Horizon Ventures', 'Series A', '\$350K', 'Meeting Tomorrow'),
                  const SizedBox(height: 20),
                  const Text('All Investors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final investors = _filteredInvestors;
                if (index >= investors.length) return null;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _InvestorCard(investor: investors[index]),
                );
              },
              childCount: _filteredInvestors.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _pipelinePill(String label, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(count, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _priorityCard(String name, String fund, String amount, String nextStep) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF0EBFF), Color(0xFFEDE9FE)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF5B21B6).withValues(alpha: 0.12),
                child: const Text('HV', style: TextStyle(color: Color(0xFF5B21B6), fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                    Text('$fund · $amount', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: Color(0xFF5B21B6)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text('NEXT STEP: $nextStep', style: const TextStyle(fontSize: 10, color: Color(0xFF5B21B6), fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 36),
                side: const BorderSide(color: Color(0xFF5B21B6)),
                foregroundColor: const Color(0xFF5B21B6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text('Schedule', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestorCard extends StatelessWidget {
  const _InvestorCard({required this.investor});
  final InvestorEntry investor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: investor.color.withValues(alpha: 0.1),
            child: Text(investor.initials, style: TextStyle(color: investor.color, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(investor.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                Text('${investor.fund} · ${investor.amount}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Last active: ${investor.status}', style: TextStyle(fontSize: 11, color: investor.statusColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View Profile', style: TextStyle(color: Color(0xFF5B21B6), fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _AddInvestorBottomSheet extends StatefulWidget {
  const _AddInvestorBottomSheet();

  @override
  State<_AddInvestorBottomSheet> createState() => _AddInvestorBottomSheetState();
}

class _AddInvestorBottomSheetState extends State<_AddInvestorBottomSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedStage = 'Seed';
  String _selectedStatus = 'Active';

  final List<String> _stages = ['Pre-Seed', 'Seed', 'Series A', 'Series B', 'Angel'];
  final List<String> _statuses = ['Active', 'Meeting Scheduled', 'Due Diligence', 'Term Sheet', 'Not Engaged'];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF5B21B6)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add Investor', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF12233D))),
                          SizedBox(height: 2),
                          Text('Add a new investor or fund to your pipeline.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFFF3F4F6)),
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7280), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _inputField('Investor / Fund Name', 'e.g. Sequoia Capital', _nameController, Icons.business_outlined),
                const SizedBox(height: 14),
                _inputField('Target Amount', 'e.g. \$250K', _amountController, Icons.attach_money_outlined),
                const SizedBox(height: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Funding Stage', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4B5563))),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedStage,
                      decoration: _inputDecoration(Icons.layers_outlined),
                      items: _stages.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStage = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pipeline Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4B5563))),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: _inputDecoration(Icons.sync_outlined),
                      items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStatus = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) return;
                      final rawAmount = _amountController.text.trim();
                      final amount = rawAmount.isEmpty ? '\$250K' : (rawAmount.startsWith('\$') ? rawAmount : '\$$rawAmount');
                      final initials = name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();

                      final newEntry = InvestorEntry(
                        name: name,
                        fund: _selectedStage,
                        amount: amount,
                        status: _selectedStatus,
                        statusColor: const Color(0xFF059669),
                        initials: initials,
                        color: const Color(0xFF5B21B6),
                        contacted: 1,
                        replied: 0,
                      );
                      Navigator.pop(context, newEntry);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add to Pipeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF5B21B6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint, TextEditingController controller, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4B5563))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: _inputDecoration(icon).copyWith(hintText: hint),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 22),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF5B21B6), width: 1.5)),
    );
  }
}
