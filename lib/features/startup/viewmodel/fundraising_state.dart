import '../model/startup_models.dart';

class FundraisingState {
  const FundraisingState({
    this.raisedAmount = 1.2,
    this.targetAmount = 2.0,
    this.meetingsCount = 12,
    this.introsCount = 4,
    this.reachCount = 150,
    this.repliesCount = 85,
    this.activeInvestors = const [],
    this.attentionTasks = const [],
    this.documents = const [],
  });

  final double raisedAmount;
  final double targetAmount;
  final int meetingsCount;
  final int introsCount;
  final int reachCount;
  final int repliesCount;
  final List<FundraisingInvestor> activeInvestors;
  final List<FundraisingTask> attentionTasks;
  final List<FundraisingDocument> documents;

  double get progress => (raisedAmount / targetAmount).clamp(0.0, 1.0);

  FundraisingState copyWith({
    double? raisedAmount,
    double? targetAmount,
    int? meetingsCount,
    int? introsCount,
    int? reachCount,
    int? repliesCount,
    List<FundraisingInvestor>? activeInvestors,
    List<FundraisingTask>? attentionTasks,
    List<FundraisingDocument>? documents,
  }) {
    return FundraisingState(
      raisedAmount: raisedAmount ?? this.raisedAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      meetingsCount: meetingsCount ?? this.meetingsCount,
      introsCount: introsCount ?? this.introsCount,
      reachCount: reachCount ?? this.reachCount,
      repliesCount: repliesCount ?? this.repliesCount,
      activeInvestors: activeInvestors ?? this.activeInvestors,
      attentionTasks: attentionTasks ?? this.attentionTasks,
      documents: documents ?? this.documents,
    );
  }
}
