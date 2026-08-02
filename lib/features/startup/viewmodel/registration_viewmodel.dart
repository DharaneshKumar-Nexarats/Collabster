import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class RegistrationViewModel extends ChangeNotifier {
  static const int totalSteps = 8;

  int _currentStep = 0;
  int get currentStep => _currentStep;
  double get progress => (_currentStep + 1) / totalSteps;

  String _selectedStage = 'Seed';
  String get selectedStage => _selectedStage;

  String _selectedTeamSize = '1-5';
  String get selectedTeamSize => _selectedTeamSize;

  String _selectedFundingStage = 'Seed';
  String get selectedFundingStage => _selectedFundingStage;

  String _selectedInviteRole = 'Founder';
  String get selectedInviteRole => _selectedInviteRole;

  String _selectedVisibility = 'Public';
  String get selectedVisibility => _selectedVisibility;

  bool _currentlyRaising = true;
  bool get currentlyRaising => _currentlyRaising;

  double _yearsOfExperience = 5;
  double get yearsOfExperience => _yearsOfExperience;

  final Set<String> _selectedSkills = {'Leadership', 'AI', 'Product'};
  Set<String> get selectedSkills => _selectedSkills;

  final List<String> _skillTags = const [
    'Leadership',
    'AI',
    'Marketing',
    'Sales',
    'Engineering',
    'Finance',
    'Design',
    'Operations',
    'Product',
  ];
  List<String> get skillTags => _skillTags;

  final List<StartupMember> _members = [
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
  ];
  List<StartupMember> get members => _members;

  final List<String> _fundingStages = const [
    'Bootstrapped',
    'Angel',
    'Pre-Seed',
    'Seed',
    'Series A',
    'Series B',
  ];
  List<String> get fundingStages => _fundingStages;

  final List<String> _visibilityOptions = const [
    'Public',
    'Private',
    'Invite Only',
  ];
  List<String> get visibilityOptions => _visibilityOptions;

  void selectStage(String stage) {
    _selectedStage = stage;
    notifyListeners();
  }

  void selectTeamSize(String size) {
    _selectedTeamSize = size;
    notifyListeners();
  }

  void selectFundingStage(String stage) {
    _selectedFundingStage = stage;
    notifyListeners();
  }

  void selectInviteRole(String role) {
    _selectedInviteRole = role;
    notifyListeners();
  }

  void selectVisibility(String visibility) {
    _selectedVisibility = visibility;
    notifyListeners();
  }

  void toggleRaising(bool value) {
    _currentlyRaising = value;
    notifyListeners();
  }

  void setYearsOfExperience(double years) {
    _yearsOfExperience = years;
    notifyListeners();
  }

  void toggleSkill(String skill) {
    if (_selectedSkills.contains(skill)) {
      _selectedSkills.remove(skill);
    } else {
      _selectedSkills.add(skill);
    }
    notifyListeners();
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  bool goToNextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool goToPreviousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool inviteTeamMember(String email, {String? role}) {
    if (email.isEmpty) return false;
    final assignedRole = role ?? _selectedInviteRole;
    _members.insert(
      0,
      StartupMember(
        name: email.split('@').first,
        role: assignedRole,
        status: 'Invite Sent',
        initials: email.isNotEmpty ? email[0].toUpperCase() : 'U',
      ),
    );
    notifyListeners();
    return true;
  }
}
