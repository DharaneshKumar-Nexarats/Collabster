import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingViewModel extends StateNotifier<int> {
  OnboardingViewModel() : super(0);

  void setPage(int index) {
    state = index;
  }
}

final onboardingViewModelProvider = StateNotifierProvider<OnboardingViewModel, int>((ref) {
  return OnboardingViewModel();
});
