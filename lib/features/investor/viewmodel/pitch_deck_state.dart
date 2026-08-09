import '../model/investor_model.dart';

class PitchDeckState {
  const PitchDeckState({
    this.pitchDecks = const [],
    this.selectedDeck,
  });

  final List<PitchDeck> pitchDecks;
  final PitchDeck? selectedDeck;

  PitchDeckState copyWith({
    List<PitchDeck>? pitchDecks,
    PitchDeck? selectedDeck,
    bool clearSelectedDeck = false,
  }) {
    return PitchDeckState(
      pitchDecks: pitchDecks ?? this.pitchDecks,
      selectedDeck: clearSelectedDeck ? null : (selectedDeck ?? this.selectedDeck),
    );
  }
}
