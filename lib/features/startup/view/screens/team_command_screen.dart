import 'package:flutter/material.dart';

import '../../model/startup_models.dart';

class TeamCommandScreen extends StatefulWidget {
  const TeamCommandScreen({super.key, required this.startupName});
  final String startupName;

  @override
  State<TeamCommandScreen> createState() => _TeamCommandScreenState();
}

class _TeamCommandScreenState extends State<TeamCommandScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final List<TeamMember> _allMembers = [
    TeamMember(
      name: 'Rahul Verma',
      role: 'Founder & CEO',
      department: 'Executive / Strategy',
      badge: 'FOUNDER',
      badgeColor: Color(0xFF5B21B6),
      initials: 'RV',
    ),
    TeamMember(
      name: 'Sneha Iyer',
      role: 'Co-Founder & CTO',
      department: 'Engineering / Tech',
      badge: 'CO-FOUNDER',
      badgeColor: Color(0xFF0D9488),
      initials: 'SI',
    ),
    TeamMember(
      name: 'Vikram Singh',
      role: 'Marketing Lead',
      department: 'Growth / Comms',
      badge: 'CORE TEAM',
      badgeColor: Color(0xFF2563EB),
      initials: 'VS',
    ),
    TeamMember(
      name: 'Anika Patel',
      role: 'Product Designer',
      department: 'Design / UX',
      badge: 'CORE TEAM',
      badgeColor: Color(0xFF2563EB),
      initials: 'AP',
    ),
  ];

  List<TeamMember> get _filteredMembers {
    switch (_selectedTab) {
      case 1:
        return _allMembers.where((m) => m.badge == 'FOUNDER' || m.badge == 'CO-FOUNDER').toList();
      case 2:
        return _allMembers.where((m) => m.badge == 'CORE TEAM').toList();
      case 3:
        return _allMembers.where((m) => m.badge != 'FOUNDER' && m.badge != 'CO-FOUNDER' && m.badge != 'CORE TEAM').toList();
      default:
        return _allMembers;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                  colors: [Color(0xFF5B21B6), Color(0xFF7C3AED), Color(0xFF4F46E5)],
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Team Members',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'YOUR TEAM',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                '12 Team Members',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _statBox('12', 'FULL-TIME'),
                            _divider(),
                            _statBox('6', 'PART-TIME'),
                            _divider(),
                            _statBox('8', 'ACTIVE'),
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
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF5B21B6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6B7280),
                      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Founders'),
                        Tab(text: 'Core Team'),
                        Tab(text: 'Emp'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Leadership',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final members = _filteredMembers;
                if (index >= members.length) return null;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _MemberCard(member: members[index]),
                );
              },
              childCount: _filteredMembers.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All', style: TextStyle(color: Color(0xFF5B21B6))),
                  ),
                  ...List.generate(
                    3,
                    (i) => _SmallMemberTile(
                      name: ['Sarah Miller', 'David Kim', 'Emma Wilson'][i],
                      role: ['Lead Designer', 'Engineer', 'Product Manager'][i],
                      status: ['Full-time', 'Full-time', 'Part-time'][i],
                      initials: ['SM', 'DK', 'EW'][i],
                    ),
                  ),
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
              onPressed: () => _showInviteSheet(context),
              icon: const Icon(Icons.add),
              label: const Text(
                '+ Invite Member',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
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

  void _showInviteSheet(BuildContext context) {
    final emailCtrl = TextEditingController();
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
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999)),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Invite Team Member', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 14),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  prefixIcon: const Icon(Icons.mail_outline),
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
                      SnackBar(content: Text('Invite sent to ${emailCtrl.text}'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Send Invite', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.2));
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});
  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFE8DBFF),
            child: Text(member.initials, style: const TextStyle(color: Color(0xFF5B21B6), fontWeight: FontWeight.w800, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(member.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: member.badgeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        member.badge,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: member.badgeColor, letterSpacing: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(member.role, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                Text(member.department, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Column(
            children: [
              _actionBtn('Contact', false),
              const SizedBox(height: 6),
              _actionBtn('Follow', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, bool filled) {
    if (filled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF5B21B6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF374151), fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _SmallMemberTile extends StatelessWidget {
  const _SmallMemberTile({required this.name, required this.role, required this.status, required this.initials});
  final String name, role, status, initials;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE8DBFF),
            child: Text(initials, style: const TextStyle(color: Color(0xFF5B21B6), fontWeight: FontWeight.w800, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
                Text('$role · $status', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

