import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'hiring_state.dart';

class HiringViewModel extends StateNotifier<HiringState> {
  HiringViewModel() : super(const HiringState());

  void loadInitialData() {
    if (state.roles.isNotEmpty) return;
    state = state.copyWith(
      roles: const [
        OpenRole(
          title: 'Senior AI Engineer',
          department: 'Core Engine / Engineering',
          applicants: 48,
          shortlisted: 6,
          status: 'HIRING',
          statusColorKey: 'live',
          salaryLpa: '25 - 35 LPA',
          skills: 'Python, PyTorch, LLMs, LangChain, CUDA',
          location: 'Remote',
          experience: '4+ Yrs',
        ),
        OpenRole(
          title: 'ML Research Lead',
          department: 'R&D / Research',
          applicants: 12,
          shortlisted: 2,
          status: 'HIRING',
          statusColorKey: 'live',
          salaryLpa: '30 - 45 LPA',
          skills: 'Computer Vision, Transformer, TensorFlow',
          location: 'Hybrid / Bangalore',
          experience: '6+ Yrs',
        ),
        OpenRole(
          title: 'Product Designer',
          department: 'Design / UI-UX',
          applicants: 24,
          shortlisted: 4,
          status: 'PAUSED',
          statusColorKey: 'beta',
          salaryLpa: '16 - 22 LPA',
          skills: 'Figma, Design Systems, User Research, Prototyping',
          location: 'Remote',
          experience: '3+ Yrs',
        ),
      ],
    );
  }

  List<OpenRole> filterRoles(String filter) {
    if (filter == 'ALL') return state.roles;
    return state.roles.where((r) => r.status == filter).toList();
  }

  void addRole(OpenRole role) {
    state = state.copyWith(roles: [role, ...state.roles]);
  }
}
