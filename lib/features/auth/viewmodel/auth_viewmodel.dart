import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/auth_session.dart';
import '../repository/auth_repository_impl.dart';
import '../repository/i_auth_repository.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this._repository) : super(const AuthState());

  final IAuthRepository _repository;

  Future<void> loadSession() async {
    state = state.copyWith(status: AuthStatus.loading);
    final session = await _repository.readSession();
    if (session != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        session: session,
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final session = await _repository.readSession();

    if (session == null) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'No saved account found. Create a new account first.',
      );
      return 'No saved account found. Create a new account first.';
    }

    if (session.email.toLowerCase() != email.toLowerCase() ||
        session.password != password) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Email or password does not match the saved account.',
      );
      return 'Email or password does not match the saved account.';
    }

    await _repository.saveSession(
      session.copyWith(onboardingComplete: true),
    );
    await _repository.markOnboardingComplete();

    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: session.copyWith(onboardingComplete: true),
    );
    return null;
  }

  Future<void> signUp(AuthSession session) async {
    state = state.copyWith(status: AuthStatus.loading);
    await _repository.saveSession(session);
    await _repository.markOnboardingComplete();
    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: session,
    );
  }

  Future<void> updateStartupData({
    required String startupName,
    String? industry,
    String? stage,
    String? tagline,
    String? country,
    String? city,
  }) async {
    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        startupName: startupName,
        startupIndustry: industry,
        startupStage: stage,
        startupTagline: tagline,
        startupCountry: country,
        startupCity: city,
      );
    });
    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> logout() async {
    await _repository.clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  AuthSession? get currentSession => state.session;
}
