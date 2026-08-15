import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/funding_round_model.dart';
import '../widgets/investor_card.dart';

/// Discover — live funding rounds and the investor network.
class DealFlowScreen extends ConsumerStatefulWidget {
  const DealFlowScreen({
    super.key,
    this.embedded = false,
    this.onViewPortfolio,
  });

  final bool embedded;
  final VoidCallback? onViewPortfolio;

  @override
  ConsumerState<DealFlowScreen> createState() => _DealFlowScreenState();
}

class _DealFlowScreenState extends ConsumerState<DealFlowScreen> {
  static const _stages = ['All', 'Pre-Seed', 'Seed', 'Series A', 'Series B'];

  String _selectedStage = 'All';

  List<FundingRound> _filtered(List<FundingRound> rounds) {
    if (_selectedStage == 'All') return rounds;
    return rounds.where((r) => r.stage == _selectedStage).toList();
  }

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  void _showInvestSheet(FundingRound round) {
    String selectedAmount = '\$25,000';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: InvestorColors.goldShimmer,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invest in ${round.startup}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: InvestorColors.ink,
                              ),
                            ),
                            Text(
                              '${round.stage} • ${round.sector}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: InvestorColors.textMuted,
                              ),
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: InvestorColors.goldBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: InvestorColors.border),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Round progress',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: InvestorColors.inkSoft,
                            ),
                          ),
                        ),
                        Text(
                          '${_compact(round.raisedAmount)} of ${_compact(round.targetAmount)}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: InvestorColors.goldDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SELECT AMOUNT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: InvestorColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['\$10,000', '\$25,000', '\$50,000', '\$100,000'].map((amount) {
                      final isSelected = amount == selectedAmount;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedAmount = amount),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: isSelected ? InvestorColors.goldDeep : InvestorColors.goldBg,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isSelected
                                  ? InvestorColors.goldDeep
                                  : InvestorColors.goldLight,
                            ),
                          ),
                          child: Text(
                            amount,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : InvestorColors.inkSoft,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        final raw = selectedAmount
                            .replaceAll(RegExp(r'[$,]'), '');
                        final amount = double.tryParse(raw) ?? 25000;
                        ref
                            .read(investorViewModelProvider.notifier)
                            .investInRound(round, amount);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Committed $selectedAmount to ${round.startup}!',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            backgroundColor: InvestorColors.goldDeep,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: InvestorColors.goldDeep,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                      label: const Text(
                        'Confirm Investment',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(investorViewModelProvider);
    final rounds = _filtered(state.fundingRounds);

    final totalCommitted = state.fundingRounds.fold<double>(
      0,
      (sum, r) => sum + r.raisedAmount,
    );
    final avgProgress = state.fundingRounds.isEmpty
        ? 0.0
        : state.fundingRounds.fold<double>(0, (sum, r) => sum + r.progress) /
            state.fundingRounds.length;

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
                          if (widget.embedded)
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.explore_rounded, color: Colors.white, size: 21),
                            )
                          else
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
                                  'Deal Flow',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Discover & fund the next big thing',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          if (widget.onViewPortfolio != null)
                            GestureDetector(
                              onTap: widget.onViewPortfolio,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.pie_chart_rounded, color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Portfolio',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _headerStat(
                            '${state.fundingRounds.length}',
                            'LIVE ROUNDS',
                            Icons.rocket_launch_rounded,
                          ),
                          const SizedBox(width: 18),
                          _headerStat(
                            _compact(totalCommitted),
                            'RAISED ACROSS DEALS',
                            Icons.payments_rounded,
                          ),
                          const SizedBox(width: 18),
                          _headerStat(
                            '${(avgProgress * 100).toStringAsFixed(0)}%',
                            'AVG FILLED',
                            Icons.percent_rounded,
                          ),
                        ],
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
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _stages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final stage = _stages[index];
                      final isSelected = stage == _selectedStage;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedStage = stage),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? InvestorColors.goldDeep : Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isSelected
                                  ? InvestorColors.goldDeep
                                  : InvestorColors.border,
                            ),
                          ),
                          child: Text(
                            stage,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : InvestorColors.inkSoft,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (rounds.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 44, color: InvestorColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'No rounds at this stage',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: InvestorColors.ink,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Try another stage filter to explore more deals.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
                        ),
                      ],
                    ),
                  )
                else
                  ...rounds.map(
                    (round) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RoundCard(
                        round: round,
                        onInvest: () => _showInvestSheet(round),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                const Text(
                  'Investor Network',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: InvestorColors.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),
                ...state.investors.map(
                  (investor) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InvestorCard(
                      investor: investor,
                      onTap: () {},
                      onFollow: () => ref
                          .read(investorViewModelProvider.notifier)
                          .toggleFollow(investor.id),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 13),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundCard extends StatelessWidget {
  const _RoundCard({required this.round, required this.onInvest});

  final FundingRound round;
  final VoidCallback onInvest;

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = InvestorColors.colorForKey(round.colorKey);
    final soft = InvestorColors.softForKey(round.colorKey);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: InvestorColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.75)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      round.startup,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: InvestorColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${round.stage} • ${round.sector} • ${round.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: InvestorColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: round.isOverfunded ? InvestorColors.greenSoft : InvestorColors.goldSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  round.isOverfunded ? 'Overfunded' : 'Open',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: round.isOverfunded ? InvestorColors.green : InvestorColors.goldDeep,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _compact(round.raisedAmount),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: InvestorColors.ink,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  'raised of ${_compact(round.targetAmount)} target',
                  style: const TextStyle(fontSize: 12, color: InvestorColors.textMuted),
                ),
              ),
              const Spacer(),
              Text(
                '${(round.progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: round.progress),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 9,
                backgroundColor: soft,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.people_rounded, size: 14, color: InvestorColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '${round.investors} investors',
                style: const TextStyle(fontSize: 11, color: InvestorColors.textMuted),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.calendar_today_rounded, size: 12, color: InvestorColors.textMuted),
              const SizedBox(width: 4),
              Text(
                'Closes ${round.closeDate}',
                style: const TextStyle(fontSize: 11, color: InvestorColors.textMuted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onInvest,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: InvestorColors.goldShimmer,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: InvestorColors.goldDeep.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Invest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 15, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}