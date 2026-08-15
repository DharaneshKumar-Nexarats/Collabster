import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/investor_model.dart';
import 'pitch_deck_state.dart';

class PitchDeckViewModel extends StateNotifier<PitchDeckState> {
  PitchDeckViewModel() : super(const PitchDeckState());

  void loadPitchDecks() {
    state = state.copyWith(
      pitchDecks: [
        PitchDeck(
          id: '1',
          title: 'Series A Pitch Deck',
          description: 'Comprehensive pitch deck for Series A fundraising',
          createdAt: DateTime(2024, 7, 15),
          slideCount: 24,
          isPublic: true,
        ),
        PitchDeck(
          id: '2',
          title: 'Seed Round Deck',
          description: 'Initial seed round presentation',
          createdAt: DateTime(2024, 6, 1),
          slideCount: 18,
          isPublic: false,
        ),
      ],
    );
  }

  void selectDeck(String deckId) {
    final deck = state.pitchDecks.firstWhere((d) => d.id == deckId);
    state = state.copyWith(selectedDeck: deck);
  }

  void clearSelection() {
    state = state.copyWith(clearSelectedDeck: true);
  }
}
