import '../model/investment_model.dart';
import '../model/investor_model.dart';
import '../model/funding_round_model.dart';

class InvestorState {
  const InvestorState({
    this.investors = const [],
    this.pitchDecks = const [],
    this.fundingRounds = const [],
    this.investments = const [],
    this.searchQuery = '',
  });

  final List<Investor> investors;
  final List<PitchDeck> pitchDecks;
  final List<FundingRound> fundingRounds;
  final List<Investment> investments;
  final String searchQuery;

  double get totalInvested =>
      investments.fold(0, (sum, i) => sum + i.invested);

  double get portfolioValue =>
      investments.fold(0, (sum, i) => sum + i.currentValue);

  double get totalGain => portfolioValue - totalInvested;

  double get roiPercent => totalInvested == 0 ? 0 : (totalGain / totalInvested) * 100;

  List<Investor> get filteredInvestors {
    if (searchQuery.isEmpty) return investors;
    final query = searchQuery.toLowerCase();
    return investors.where((i) =>
        i.name.toLowerCase().contains(query) ||
        i.firm.toLowerCase().contains(query) ||
        i.focus.toLowerCase().contains(query)).toList();
  }

  InvestorState copyWith({
    List<Investor>? investors,
    List<PitchDeck>? pitchDecks,
    List<FundingRound>? fundingRounds,
    List<Investment>? investments,
    String? searchQuery,
  }) {
    return InvestorState(
      investors: investors ?? this.investors,
      pitchDecks: pitchDecks ?? this.pitchDecks,
      fundingRounds: fundingRounds ?? this.fundingRounds,
      investments: investments ?? this.investments,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}