/// A single portfolio holding / deal the investor has committed capital to.
class Investment {
  final String id;
  final String company;
  final String sector;
  final String stage;
  final double invested;
  final double currentValue;
  final double equity;
  final String round;
  final String colorKey;

  const Investment({
    required this.id,
    required this.company,
    required this.sector,
    required this.stage,
    required this.invested,
    required this.currentValue,
    required this.equity,
    required this.round,
    required this.colorKey,
  });

  double get returnMultiple => invested == 0 ? 0 : currentValue / invested;

  double get gain => currentValue - invested;

  bool get isProfit => gain >= 0;
}