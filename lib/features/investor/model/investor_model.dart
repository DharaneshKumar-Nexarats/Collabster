export 'pitch_deck_model.dart';

class Investor {
  final String id;
  final String name;
  final String firm;
  final String focus;
  final String location;
  final double investmentRange;
  final int portfolioSize;
  final String initials;
  final String colorKey;
  final bool isFollowing;

  const Investor({
    required this.id,
    required this.name,
    required this.firm,
    required this.focus,
    required this.location,
    required this.investmentRange,
    required this.portfolioSize,
    required this.initials,
    required this.colorKey,
    this.isFollowing = false,
  });
}