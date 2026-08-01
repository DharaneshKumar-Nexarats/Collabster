import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  AuthViewModel() : super(const AsyncValue.data(null));

  // TODO: Add methods for sign in, sign up, sign out
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  return AuthViewModel();
});
