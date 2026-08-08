import '../../auth/repository/auth_repository_impl.dart';
import '../../auth/repository/i_auth_repository.dart';
import 'i_onboarding_repository.dart';

class OnboardingRepositoryImpl implements IOnboardingRepository {
  OnboardingRepositoryImpl({IAuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl();

  final IAuthRepository _authRepository;

  @override
  Future<bool> isOnboardingComplete() =>
      _authRepository.isOnboardingComplete();

  @override
  Future<void> markOnboardingComplete() =>
      _authRepository.markOnboardingComplete();
}
