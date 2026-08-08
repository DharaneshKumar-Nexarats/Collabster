import '../model/auth_session.dart';
import '../services/local_auth_storage.dart';
import 'i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({LocalAuthStorage? storage})
      : _storage = storage ?? LocalAuthStorage();

  final LocalAuthStorage _storage;

  @override
  Future<AuthSession?> readSession() => _storage.readSession();

  @override
  Future<void> saveSession(AuthSession session) => _storage.saveSession(session);

  @override
  Future<void> updateSession(AuthSession? Function(AuthSession? current) update) =>
      _storage.updateSession(update);

  @override
  Future<void> clearSession() => _storage.clearSession();

  @override
  Future<bool> isOnboardingComplete() => _storage.isOnboardingComplete();

  @override
  Future<void> markOnboardingComplete() => _storage.markOnboardingComplete();
}
