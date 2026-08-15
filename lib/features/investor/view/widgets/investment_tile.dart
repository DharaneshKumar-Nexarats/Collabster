import 'package:flutter/material.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/investment_model.dart';

/// Row-style card showing a single portfolio holding.
class InvestmentTile extends StatelessWidget {
  const InvestmentTile({super.key, required this.investment, this.onTap});

  final Investment investment;
  final VoidCallback? onTap;

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = InvestorColors.colorForKey(investment.colorKey);
    final soft = InvestorColors.softForKey(investment.colorKey);
    final profit = investment.isProfit;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: InvestorColors.card,
          borderRadius: BorderRadius.circular(18),
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: soft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.business_rounded, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        investment.company,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: InvestorColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${investment.sector} • ${investment.round}',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _compact(investment.currentValue),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: InvestorColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: profit ? InvestorColors.greenSoft : InvestorColors.redSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${profit ? '+' : ''}${_compact(investment.gain)}',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: profit ? InvestorColors.green : InvestorColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _miniStat('INVESTED', _compact(investment.invested)),
                _divider(),
                _miniStat('EQUITY', '${investment.equity.toStringAsFixed(1)}%'),
                _divider(),
                _miniStat('MULTIPLE', '${investment.returnMultiple.toStringAsFixed(1)}x'),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: investment.returnMultiple / 3),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: soft,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: InvestorColors.textMuted,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: InvestorColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: InvestorColors.border,
    );
  }
}