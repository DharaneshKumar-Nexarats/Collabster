import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/repository/auth_repository_impl.dart';
import '../../features/auth/repository/i_auth_repository.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/auth/viewmodel/auth_state.dart';
import '../../features/startup/model/startup_models.dart';
import '../theme/theme_provider.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});

final themeProviderInstance = ChangeNotifierProvider<ThemeProvider>((ref) {
  return ThemeProvider();
});

// ---------------------------------------------------------------------------
// Frontend-only startup registry (replaces backend API for now).
// When the registration flow publishes a startup it is added here.
// The Join Startup screen reads from this list alongside the hardcoded seeds.
// ---------------------------------------------------------------------------
class StartupRegistryNotifier extends StateNotifier<List<SuggestedStartup>> {
  StartupRegistryNotifier() : super(const []);

  void addStartup(SuggestedStartup startup) {
    state = [startup, ...state];
  }
}

final startupRegistryProvider =
    StateNotifierProvider<StartupRegistryNotifier, List<SuggestedStartup>>(
  (ref) => StartupRegistryNotifier(),
);
