import 'package:flutter/foundation.dart';
import '../model/startup_models.dart';

class HiringViewModel extends ChangeNotifier {
  final List<OpenRole> _roles = [
    const OpenRole(
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
    const OpenRole(
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
    const OpenRole(
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
  ];

  List<OpenRole> get roles => List.unmodifiable(_roles);

  int get totalApplicants => _roles.fold(0, (sum, r) => sum + r.applicants);
  int get totalShortlisted => _roles.fold(0, (sum, r) => sum + r.shortlisted);
  int get totalInterviews => 12;

  List<OpenRole> filterRoles(String filter) {
    if (filter == 'ALL') return roles;
    return _roles.where((r) => r.status == filter).toList();
  }

  void addRole(OpenRole role) {
    _roles.insert(0, role);
    notifyListeners();
  }
}
