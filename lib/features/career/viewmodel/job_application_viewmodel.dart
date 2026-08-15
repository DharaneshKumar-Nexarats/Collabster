import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/job_model.dart';
import 'job_application_state.dart';

class JobApplicationViewModel extends StateNotifier<JobApplicationState> {
  JobApplicationViewModel() : super(const JobApplicationState());

  void loadApplications() {
    state = state.copyWith(
      applications: [
        JobApplication(
          id: '1',
          jobId: 'j1',
          jobTitle: 'Senior Software Engineer',
          company: 'Google',
          status: 'Applied',
          appliedAt: DateTime(2024, 8, 1),
        ),
        JobApplication(
          id: '2',
          jobId: 'j2',
          jobTitle: 'Product Designer',
          company: 'Stripe',
          status: 'Interview',
          appliedAt: DateTime(2024, 7, 28),
        ),
      ],
    );
  }

  void setStatusFilter(String status) {
    state = state.copyWith(selectedStatus: status);
  }
}
