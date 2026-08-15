import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/job_model.dart';
import 'career_state.dart';

class CareerViewModel extends StateNotifier<CareerState> {
  CareerViewModel() : super(const CareerState());

  void loadInitialData() {
    state = state.copyWith(
      jobs: const [
        JobItem(
          logo: 'code_rounded',
          title: 'Senior Software Engineer',
          company: 'Google',
          location: 'Mountain View (Hybrid)',
          salaryTag: '24 - 32 LPA',
          tags: ['React', 'Node.js', 'Go'],
          timeAgo: '2 hours ago',
          showNew: true,
          roleType: 'job',
        ),
        JobItem(
          logo: 'design_services_outlined',
          title: 'Product Designer',
          company: 'Stripe',
          location: 'Remote',
          salaryTag: '18 - 25 LPA',
          tags: ['Figma', 'Prototyping', 'Design Systems'],
          timeAgo: '5 hours ago',
          roleType: 'job',
        ),
        JobItem(
          logo: 'analytics_outlined',
          title: 'Data Analyst',
          company: 'Microsoft',
          location: 'Bangalore (On-site)',
          salaryTag: '15 - 22 LPA',
          tags: ['Python', 'SQL', 'Tableau'],
          timeAgo: '1 day ago',
          roleType: 'job',
        ),
        JobItem(
          logo: 'school_outlined',
          title: 'Software Engineering Intern',
          company: 'Meta',
          location: 'London (Hybrid)',
          salaryTag: 'Stipend: 2,500 GBP/mo',
          tags: ['React Native', 'GraphQL', 'TypeScript'],
          timeAgo: '3 hours ago',
          showNew: true,
          roleType: 'internship',
        ),
        JobItem(
          logo: 'school_outlined',
          title: 'Machine Learning Intern',
          company: 'DeepMind',
          location: 'Remote (UK)',
          salaryTag: 'Stipend: 3,000 GBP/mo',
          tags: ['Python', 'PyTorch', 'Research'],
          timeAgo: '1 day ago',
          roleType: 'internship',
        ),
        JobItem(
          logo: 'school_outlined',
          title: 'Frontend Intern',
          company: 'Vercel',
          location: 'San Francisco (Hybrid)',
          salaryTag: 'Stipend: 8,000 USD/mo',
          tags: ['Next.js', 'TypeScript', 'Tailwind'],
          timeAgo: '2 days ago',
          roleType: 'internship',
        ),
      ],
    );
  }

  void setFilter(int index) {
    state = state.copyWith(selectedFilter: index);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void applyToJob(String jobId) {
    final job = state.jobs.firstWhere((j) => j.title == jobId);
    final application = JobApplication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobId: jobId,
      jobTitle: job.title,
      company: job.company,
      status: 'Applied',
      appliedAt: DateTime.now(),
    );
    state = state.copyWith(applications: [...state.applications, application]);
  }
}
