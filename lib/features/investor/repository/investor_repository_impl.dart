import '../model/investor_model.dart';
import 'i_investor_repository.dart';

class InvestorRepositoryImpl implements IInvestorRepository {
  @override
  Future<List<Investor>> fetchInvestors() async {
    return const [
      Investor(
        id: '1',
        name: 'Vertex Capital',
        firm: 'Vertex Capital',
        focus: 'Series A',
        location: 'San Francisco',
        investmentRange: 500000,
        portfolioSize: 45,
        initials: 'VC',
        colorKey: 'gold',
      ),
    ];
  }

  @override
  Future<List<PitchDeck>> fetchPitchDecks() async {
    return const [];
  }
}