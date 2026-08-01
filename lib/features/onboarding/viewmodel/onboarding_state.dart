class OnboardingState {
  const OnboardingState({
    this.currentPage = 0,
    this.isComplete = false,
  });

  final int currentPage;
  final bool isComplete;

  OnboardingState copyWith({int? currentPage, bool? isComplete}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
