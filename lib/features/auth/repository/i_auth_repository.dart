import '../model/auth_session.dart';

abstract class IAuthRepository {
  Future<AuthSession?> readSession();
  Future<void> saveSession(AuthSession session);
  Future<void> updateSession(AuthSession? Function(AuthSession? current) update);
  Future<void> clearSession();
  Future<bool> isOnboardingComplete();
  Future<void> markOnboardingComplete();
}
