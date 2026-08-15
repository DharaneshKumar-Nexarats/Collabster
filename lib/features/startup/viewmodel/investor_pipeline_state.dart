import '../model/startup_models.dart';

class InvestorPipelineState {
  const InvestorPipelineState({
    this.discoverInvestors = const [],
    this.pipelineInvestors = const [],
    this.savedInvestors = const [],
  });

  final List<InvestorEntry> discoverInvestors;
  final List<InvestorEntry> pipelineInvestors;
  final List<InvestorEntry> savedInvestors;

  bool isSaved(String name) => savedInvestors.any((i) => i.name == name);

  InvestorPipelineState copyWith({
    List<InvestorEntry>? discoverInvestors,
    List<InvestorEntry>? pipelineInvestors,
    List<InvestorEntry>? savedInvestors,
  }) {
    return InvestorPipelineState(
      discoverInvestors: discoverInvestors ?? this.discoverInvestors,
      pipelineInvestors: pipelineInvestors ?? this.pipelineInvestors,
      savedInvestors: savedInvestors ?? this.savedInvestors,
    );
  }
}
