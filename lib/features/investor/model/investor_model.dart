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

class PitchDeck {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final int slideCount;
  final bool isPublic;

  PitchDeck({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.slideCount = 0,
    this.isPublic = false,
  });
}

class FundingRound {
  final String id;
  final String name;
  final String targetAmount;
  final String raisedAmount;
  final String status;
  final DateTime startDate;

  const FundingRound({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.raisedAmount,
    required this.status,
    required this.startDate,
  });
}
