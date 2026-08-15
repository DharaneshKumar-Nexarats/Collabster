import 'package:flutter/material.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/investor_model.dart';

/// Card representing a startup pitch deck available to review.
class PitchDeckCard extends StatelessWidget {
  const PitchDeckCard({super.key, required this.deck, this.onTap});

  final PitchDeck deck;
  final VoidCallback? onTap;

  String get _dateLabel {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[deck.createdAt.month - 1]} ${deck.createdAt.day}, ${deck.createdAt.year}';
  }

  @override
  Widget build(BuildContext context) {
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
              height: 62,
              decoration: BoxDecoration(
                gradient: InvestorColors.goldShimmer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${deck.slideCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deck.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: InvestorColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        _dateLabel,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: InvestorColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: deck.isPublic
                              ? InvestorColors.greenSoft
                              : InvestorColors.goldSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          deck.isPublic ? 'Public' : 'Private',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: deck.isPublic
                                ? InvestorColors.green
                                : InvestorColors.goldDeep,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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