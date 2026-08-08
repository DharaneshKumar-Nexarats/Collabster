import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, void>((ref) {
  return HomeViewModel(ref.read(authViewModelProvider.notifier));
});

class HomeViewModel extends StateNotifier<void> {
  HomeViewModel(this._authVM) : super(null);

  final AuthViewModel _authVM;

  Future<void> logout() async {
    await _authVM.logout();
  }
}
