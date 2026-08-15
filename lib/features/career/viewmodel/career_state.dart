import '../model/job_model.dart';

class CareerState {
  const CareerState({
    this.jobs = const [],
    this.applications = const [],
    this.resumes = const [],
    this.selectedFilter = 0,
    this.searchQuery = '',
  });

  final List<JobItem> jobs;
  final List<JobApplication> applications;
  final List<Resume> resumes;
  final int selectedFilter;
  final String searchQuery;

  List<JobItem> get filteredJobs {
    final filters = ['All Roles', 'Remote', 'Paid', 'Hybrid'];
    final filter = filters[selectedFilter].toLowerCase();

    return jobs.where((job) {
      if (filter == 'remote' && !job.location.toLowerCase().contains('remote')) {
        return false;
      }
      if (filter == 'hybrid' && !job.location.toLowerCase().contains('hybrid')) {
        return false;
      }
      if (filter == 'paid' && !job.salaryTag.isNotEmpty) {
        return false;
      }

      if (searchQuery.isEmpty) return true;
      final query = searchQuery.toLowerCase();
      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query) ||
          job.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();
  }

  CareerState copyWith({
    List<JobItem>? jobs,
    List<JobApplication>? applications,
    List<Resume>? resumes,
    int? selectedFilter,
    String? searchQuery,
  }) {
    return CareerState(
      jobs: jobs ?? this.jobs,
      applications: applications ?? this.applications,
      resumes: resumes ?? this.resumes,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
