import '../model/job_model.dart';

class JobApplicationState {
  const JobApplicationState({
    this.applications = const [],
    this.selectedStatus = 'All',
  });

  final List<JobApplication> applications;
  final String selectedStatus;

  List<JobApplication> get filteredApplications {
    if (selectedStatus == 'All') return applications;
    return applications.where((a) => a.status == selectedStatus).toList();
  }

  JobApplicationState copyWith({
    List<JobApplication>? applications,
    String? selectedStatus,
  }) {
    return JobApplicationState(
      applications: applications ?? this.applications,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}
