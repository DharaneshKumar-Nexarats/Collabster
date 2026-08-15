import '../model/investor_model.dart';

class InvestorState {
  const InvestorState({
    this.investors = const [],
    this.pitchDecks = const [],
    this.fundingRounds = const [],
    this.searchQuery = '',
  });

  final List<Investor> investors;
  final List<PitchDeck> pitchDecks;
  final List<FundingRound> fundingRounds;
  final String searchQuery;

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
    String? searchQuery,
  }) {
    return InvestorState(
      investors: investors ?? this.investors,
      pitchDecks: pitchDecks ?? this.pitchDecks,
      fundingRounds: fundingRounds ?? this.fundingRounds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
