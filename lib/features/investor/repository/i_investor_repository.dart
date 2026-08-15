import '../model/investor_model.dart';

abstract class IInvestorRepository {
  Future<List<Investor>> fetchInvestors();

  Future<List<PitchDeck>> fetchPitchDecks();
}