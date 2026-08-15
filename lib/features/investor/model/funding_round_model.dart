/// A live funding round a startup is raising — an opportunity for investors.
class FundingRound {
  final String id;
  final String startup;
  final String sector;
  final String stage;
  final double targetAmount;
  final double raisedAmount;
  final String location;
  final String colorKey;
  final int investors;
  final String closeDate;

  const FundingRound({
    required this.id,
    required this.startup,
    required this.sector,
    required this.stage,
    required this.targetAmount,
    required this.raisedAmount,
    required this.location,
    required this.colorKey,
    required this.investors,
    required this.closeDate,
  });

  double get progress =>
      targetAmount == 0 ? 0 : (raisedAmount / targetAmount).clamp(0.0, 1.0);

  bool get isOverfunded => raisedAmount >= targetAmount;
}