import '../model/startup_models.dart';

class JoinStartupState {
  const JoinStartupState({
    this.selectedMode = 'Startup Name',
    this.suggestedStartups = const [],
  });

  final String selectedMode;
  final List<SuggestedStartup> suggestedStartups;

  JoinStartupState copyWith({
    String? selectedMode,
    List<SuggestedStartup>? suggestedStartups,
  }) {
    return JoinStartupState(
      selectedMode: selectedMode ?? this.selectedMode,
      suggestedStartups: suggestedStartups ?? this.suggestedStartups,
    );
  }
}
