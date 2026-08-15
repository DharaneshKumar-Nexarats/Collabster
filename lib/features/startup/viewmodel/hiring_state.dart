import '../model/startup_models.dart';

class HiringState {
  const HiringState({
    this.roles = const [],
  });

  final List<OpenRole> roles;

  int get totalApplicants => roles.fold(0, (sum, r) => sum + r.applicants);
  int get totalShortlisted => roles.fold(0, (sum, r) => sum + r.shortlisted);
  int get totalInterviews => 12;

  HiringState copyWith({
    List<OpenRole>? roles,
  }) {
    return HiringState(
      roles: roles ?? this.roles,
    );
  }
}
