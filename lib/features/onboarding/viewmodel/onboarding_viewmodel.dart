import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, int>((ref) {
  return OnboardingViewModel(ref.read(authViewModelProvider.notifier));
});

class OnboardingViewModel extends StateNotifier<int> {
  OnboardingViewModel(this._authVM) : super(0);

  final AuthViewModel _authVM;

  void setPage(int index) => state = index;

  Future<bool> checkOnboardingComplete() async {
    await _authVM.loadSession();
    return _authVM.currentSession != null;
  }
}
