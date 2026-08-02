import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/enums/app_enums.dart';
import '../../startup/model/startup_models.dart';
import '../model/auth_session.dart';
import '../repository/i_auth_repository.dart';
import 'auth_state.dart';

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
    final sessionWithRoles = session.copyWith(
      roles: [session.role],
      activeRole: session.role,
    );
    await _repository.saveSession(sessionWithRoles);
    await _repository.markOnboardingComplete();
    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: sessionWithRoles,
    );
  }

  Future<void> switchRole(UserRole newRole) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    final currentRoles = currentSession.userRoles.map((r) => r.name).toList();
    if (!currentRoles.contains(newRole.name)) {
      currentRoles.add(newRole.name);
    }

    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        activeRole: newRole.name,
        roles: currentRoles,
      );
    });

    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> addRole(UserRole newRole) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    final currentRoles = currentSession.userRoles.map((r) => r.name).toList();
    if (currentRoles.contains(newRole.name)) {
      await switchRole(newRole);
      return;
    }

    currentRoles.add(newRole.name);

    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        activeRole: newRole.name,
        roles: currentRoles,
      );
    });

    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> updateStartupData({
    required String startupName,
    String? industry,
    String? stage,
    String? tagline,
    String? logoPath,
    String? coverPath,
    String? country,
    String? city,
    String? description,
    String? problem,
    String? solution,
    String? mission,
    String? vision,
    String? website,
    String? incorporationDate,
    String? founderName,
    String? founderDesignation,
    String? founderEmail,
    String? founderPhone,
    String? founderLinkedin,
    String? founderBio,
    String? socialWebsite,
    String? socialLinkedin,
    String? socialProductHunt,
    String? useOfFunds,
    String? teamSize,
    String? fundingStage,
    bool? currentlyRaising,
    String? visibility,
    String? originalStartupName,
    Map<String, dynamic>? originalStartupData,
    String? joinedStartupName,
    Map<String, dynamic>? joinedStartupData,
    bool clearJoinedStartup = false,
  }) async {
    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        startupName: startupName,
        startupIndustry: industry,
        startupStage: stage,
        startupTagline: tagline,
        startupLogoPath: logoPath,
        startupCoverPath: coverPath,
        startupCountry: country,
        startupCity: city,
        startupDescription: description,
        startupProblem: problem,
        startupSolution: solution,
        startupMission: mission,
        startupVision: vision,
        startupWebsite: website,
        startupIncorporationDate: incorporationDate,
        startupFounderName: founderName,
        startupFounderDesignation: founderDesignation,
        startupFounderEmail: founderEmail,
        startupFounderPhone: founderPhone,
        startupFounderLinkedin: founderLinkedin,
        startupFounderBio: founderBio,
        startupSocialWebsite: socialWebsite,
        startupSocialLinkedin: socialLinkedin,
        startupSocialProductHunt: socialProductHunt,
        startupUseOfFunds: useOfFunds,
        startupTeamSize: teamSize,
        startupFundingStage: fundingStage,
        startupCurrentlyRaising: currentlyRaising,
        startupVisibility: visibility,
        originalStartupName: originalStartupName,
        originalStartupData: originalStartupData,
        joinedStartupName: joinedStartupName,
        joinedStartupData: joinedStartupData,
        clearJoinedStartup: clearJoinedStartup,
      );
    });
    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }


  Future<void> addPost(StartupPost post) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    final updatedPosts = [post, ...currentSession.posts];

    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(posts: updatedPosts);
    });

    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> updateProfilePhoto(String photoPath) async {
    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        profilePhotoPath: photoPath,
        profilePhotoLabel: 'Photo uploaded',
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
