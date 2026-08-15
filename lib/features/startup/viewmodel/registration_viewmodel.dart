import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'registration_state.dart';

class RegistrationViewModel extends StateNotifier<RegistrationState> {
  RegistrationViewModel() : super(const RegistrationState());

  void loadInitialData() {
    state = state.copyWith(
      members: const [
        StartupMember(
          name: 'Sarah Jenkins',
          role: 'CEO & Co-founder',
          status: 'Active',
          initials: 'SJ',
        ),
        StartupMember(
          name: 'Marcus Zhao',
          role: 'Lead Developer',
          status: 'Invite Sent',
          initials: 'MZ',
        ),
      ],
    );
  }

  void selectStage(String stage) {
    state = state.copyWith(selectedStage: stage);
  }

  void selectTeamSize(String size) {
    state = state.copyWith(selectedTeamSize: size);
  }

  void selectFundingStage(String stage) {
    state = state.copyWith(selectedFundingStage: stage);
  }

  void selectInviteRole(String role) {
    state = state.copyWith(selectedInviteRole: role);
  }

  void selectVisibility(String visibility) {
    state = state.copyWith(selectedVisibility: visibility);
  }

  void toggleRaising(bool value) {
    state = state.copyWith(currentlyRaising: value);
  }

  void setYearsOfExperience(double years) {
    state = state.copyWith(yearsOfExperience: years);
  }

  void toggleSkill(String skill) {
    final updatedSkills = Set<String>.from(state.selectedSkills);
    if (updatedSkills.contains(skill)) {
      updatedSkills.remove(skill);
    } else {
      updatedSkills.add(skill);
    }
    state = state.copyWith(selectedSkills: updatedSkills);
  }

  void setCurrentStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  bool goToNextStep() {
    if (state.currentStep < RegistrationState.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    return false;
  }

  bool goToPreviousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      return true;
    }
    return false;
  }

  bool inviteTeamMember(String email, {String? role}) {
    if (email.isEmpty) return false;
    final assignedRole = role ?? state.selectedInviteRole;
    final newMember = StartupMember(
      name: email.split('@').first,
      role: assignedRole,
      status: 'Invite Sent',
      initials: email.isNotEmpty ? email[0].toUpperCase() : 'U',
    );
    state = state.copyWith(members: [newMember, ...state.members]);
    return true;
  }
}
