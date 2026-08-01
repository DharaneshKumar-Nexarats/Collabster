abstract class IOnboardingRepository {
  Future<bool> isOnboardingComplete();
  Future<void> markOnboardingComplete();
}
