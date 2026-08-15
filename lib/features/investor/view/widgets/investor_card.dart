import 'package:flutter/material.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/investor_model.dart';

/// Card listing an investor / fund with a follow action.
class InvestorCard extends StatelessWidget {
  const InvestorCard({
    super.key,
    required this.investor,
    required this.onTap,
    this.onFollow,
  });

  final Investor investor;
  final VoidCallback onTap;
  final VoidCallback? onFollow;

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    return '\$${(value / 1000).toStringAsFixed(0)}K';
  }

  @override
  Widget build(BuildContext context) {
    final color = InvestorColors.colorForKey(investor.colorKey);
    final soft = InvestorColors.softForKey(investor.colorKey);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: InvestorColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: InvestorColors.border),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.75)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  investor.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investor.name,
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
                    '${investor.focus} • ${investor.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: InvestorColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: soft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _compact(investor.investmentRange),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${investor.portfolioSize} portfolio companies',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: InvestorColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (onFollow != null)
              GestureDetector(
                onTap: onFollow,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: investor.isFollowing ? color : soft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: investor.isFollowing ? color : color.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        investor.isFollowing
                            ? Icons.check_rounded
                            : Icons.add_rounded,
                        size: 14,
                        color: investor.isFollowing ? Colors.white : color,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        investor.isFollowing ? 'Following' : 'Follow',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: investor.isFollowing ? Colors.white : color,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: InvestorColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}