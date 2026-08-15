import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/cross_conversation_model.dart';
import '../../model/investor_model.dart';
import 'cross_conversation_chat_screen.dart';

/// Rich detail view for a fund / investor in the network.
class InvestorDetailScreen extends ConsumerStatefulWidget {
  const InvestorDetailScreen({super.key, required this.investor});

  final Investor investor;

  @override
  ConsumerState<InvestorDetailScreen> createState() => _InvestorDetailScreenState();
}

class _InvestorDetailScreenState extends ConsumerState<InvestorDetailScreen> {
  int _activeTab = 0; // 0: Overview, 1: Thesis & Criteria, 2: Portfolio & Deals

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  void _showIntroRequestSheet() {
    final noteController = TextEditingController();
    String selectedDeal = 'Nova Robotics (Series A)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: InvestorColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: InvestorColors.goldShimmer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.handshake_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Request Intro to ${widget.investor.name}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: InvestorColors.ink,
                                ),
                              ),
                              Text(
                                '${widget.investor.firm} • ${widget.investor.location}',
                                style: const TextStyle(fontSize: 12, color: InvestorColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, color: InvestorColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'SELECT STARTUP / DEAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: InvestorColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: InvestorColors.goldBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: InvestorColors.goldLight),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDeal,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: InvestorColors.ink),
                          items: const [
                            DropdownMenuItem(value: 'Nova Robotics (Series A)', child: Text('Nova Robotics (Series A)')),
                            DropdownMenuItem(value: 'FinEdge (Seed)', child: Text('FinEdge (Seed)')),
                            DropdownMenuItem(value: 'Cloudly AI (Pre-Seed)', child: Text('Cloudly AI (Pre-Seed)')),
                            DropdownMenuItem(value: 'Direct Personal Intro', child: Text('Direct Personal Intro')),
                          ],
                          onChanged: (val) {
                            if (val != null) setSheetState(() => selectedDeal = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'INTRO MESSAGE / THESIS NOTE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: InvestorColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14, color: InvestorColors.ink),
                      decoration: InputDecoration(
                        hintText: 'Briefly state why this introduction is a strategic fit...',
                        hintStyle: const TextStyle(fontSize: 13, color: InvestorColors.textMuted),
                        fillColor: InvestorColors.goldBg,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: InvestorColors.goldLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: InvestorColors.goldLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: InvestorColors.goldDeep, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Intro request for $selectedDeal sent to ${widget.investor.name}!'),
                              backgroundColor: InvestorColors.goldDeep,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: InvestorColors.goldDeep,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text(
                          'Send Intro Request',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openDirectMessage() {
    final conversation = CrossConversation(
      id: 'convo_${widget.investor.id}',
      participant1Id: 'investor-1',
      participant1Name: 'You (Investor)',
      participant1Role: 'investor',
      participant1Avatar: 'YU',
      participant2Id: widget.investor.id,
      participant2Name: widget.investor.name,
      participant2Role: 'investor',
      participant2Avatar: widget.investor.initials,
      lastMessage: 'Hi ${widget.investor.name}, I checked out your investment focus and would love to connect!',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      isOnline: true,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrossConversationChatScreen(conversation: conversation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = InvestorColors.colorForKey(widget.investor.colorKey);

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: 0.9), InvestorColors.goldDeep],
                ),
              ),
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
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 21),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Investor Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _openDirectMessage,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 21),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.investor.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.investor.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  widget.investor.firm,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 13, color: Colors.white70),
                                    const SizedBox(width: 3),
                                    Text(
                                      widget.investor.location,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            _headerStat('FOCUS', widget.investor.focus),
                            _divider(),
                            _headerStat('RANGE', _compact(widget.investor.investmentRange)),
                            _divider(),
                            _headerStat('PORTFOLIO', '${widget.investor.portfolioSize} Deals'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tab Selection Pills
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: InvestorColors.border),
                  ),
                  child: Row(
                    children: [
                      _tabPill(0, 'Overview'),
                      _tabPill(1, 'Thesis'),
                      _tabPill(2, 'Deals'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (_activeTab == 0) ...[
                  const Text(
                    'About Investor',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.investor.name} is an active ${widget.investor.focus.toLowerCase()} investor '
                    'focused on early-stage tech startups with strong product-market fit. '
                    'They lead and participate in investment rounds across fintech, AI, healthtech '
                    'and deeptech, typically investing between '
                    '${_compact(widget.investor.investmentRange / 2)} and '
                    '${_compact(widget.investor.investmentRange)} per deal.',
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      color: InvestorColors.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sector Interests',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      'Fintech',
                      'AI / SaaS',
                      'HealthTech',
                      'Climate Tech',
                      'Deep Tech',
                    ].map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          color: InvestorColors.goldSoft,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: InvestorColors.goldLight),
                        ),
                        child: Text(
                          s,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: InvestorColors.goldDeep,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ] else if (_activeTab == 1) ...[
                  const Text(
                    'Investment Criteria',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _criteriaRow(Icons.check_circle_rounded, 'Minimum Revenue', '\$10K Monthly Recurring Revenue'),
                        const SizedBox(height: 12),
                        _criteriaRow(Icons.check_circle_rounded, 'Geographic Focus', widget.investor.location),
                        const SizedBox(height: 12),
                        _criteriaRow(Icons.check_circle_rounded, 'Preferred Valuation', '\$3M - \$15M Cap'),
                        const SizedBox(height: 12),
                        _criteriaRow(Icons.check_circle_rounded, 'Lead or Follow', 'Leads seed rounds, follows Series A'),
                      ],
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Notable Investments',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                    ),
                    child: Column(
                      children: [
                        _dealRow('Nova Robotics', 'Robotics • Series A', '\$400K Check'),
                        const Divider(height: 16, color: InvestorColors.border),
                        _dealRow('FinEdge', 'Fintech • Seed', '\$200K Check'),
                        const Divider(height: 16, color: InvestorColors.border),
                        _dealRow('Cloudly AI', 'AI / SaaS • Pre-Seed', '\$150K Check'),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _showIntroRequestSheet,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          backgroundColor: InvestorColors.goldDeep,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.handshake_rounded, size: 20),
                        label: const Text(
                          'Request Intro',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () =>
                          ref.read(investorViewModelProvider.notifier).toggleFollow(widget.investor.id),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: widget.investor.isFollowing
                              ? color.withValues(alpha: 0.15)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withValues(alpha: 0.4)),
                        ),
                        child: Icon(
                          widget.investor.isFollowing ? Icons.check_rounded : Icons.add_rounded,
                          color: color,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabPill(int index, String title) {
    final selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? InvestorColors.goldDeep : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? Colors.white : InvestorColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }

  Widget _criteriaRow(IconData icon, String title, String detail) {
    return Row(
      children: [
        Icon(icon, size: 18, color: InvestorColors.goldDeep),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: InvestorColors.textMuted)),
            Text(detail, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: InvestorColors.ink)),
          ],
        ),
      ],
    );
  }

  Widget _dealRow(String name, String sub, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: InvestorColors.ink)),
            Text(sub, style: const TextStyle(fontSize: 11.5, color: InvestorColors.textMuted)),
          ],
        ),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: InvestorColors.goldDeep)),
      ],
    );
  }

  Widget _headerStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}