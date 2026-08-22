import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'hiring_state.dart';

class HiringViewModel extends StateNotifier<HiringState> {
  HiringViewModel() : super(const HiringState());

  void loadInitialData() {
    // Start with empty state - no dummy data
    // Jobs will only appear after startup is verified and creates them
  }

  List<OpenRole> filterRoles(String filter) {
    if (filter == 'ALL') return state.roles;
    return state.roles.where((r) => r.status == filter).toList();
  }

  void addRole(OpenRole role) {
    state = state.copyWith(roles: [role, ...state.roles]);
  }

  /// Increment applicants for a role by title (called when external applications come in)
  void incrementApplicantsForRole(String roleTitle) {
    final updated = state.roles.map((r) {
      if (r.title == roleTitle && r.status == 'HIRING') {
        return OpenRole(
          title: r.title,
          department: r.department,
          applicants: r.applicants + 1,
          shortlisted: r.shortlisted,
          status: r.status,
          statusColorKey: r.statusColorKey,
          salaryLpa: r.salaryLpa,
          skills: r.skills,
          location: r.location,
          experience: r.experience,
          roleType: r.roleType,
        );
      }
      return r;
    }).toList();
    state = state.copyWith(roles: updated);
  }
}
