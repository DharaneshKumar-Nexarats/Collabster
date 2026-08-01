import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class MilestonesViewModel extends ChangeNotifier {
  final List<Milestone> _milestones = [
    Milestone(title: 'Idea Created', date: 'Jan 15, 2023 • Initial ideation phase', completed: true, active: false),
    Milestone(title: 'Team Assembled', date: 'Feb 25, 2023 • Core engineering team hired', completed: true, active: false),
    Milestone(title: 'Seed Funding Secured', date: 'May 10, 2023 • First \$50K from early VC', completed: true, active: false),
    Milestone(title: 'Beta Phase Started', date: 'Sep 4, 2023 • Feature complete, stability testing', completed: true, active: false),
    Milestone(title: 'MVP Launched', date: 'In Progress - Feature complete, stability testing', completed: false, active: true),
    Milestone(title: 'First 1,000 Customers', date: 'Expected: June 2024', completed: false, active: false),
    Milestone(title: 'Series A Funding', date: 'Expected: June 2024', completed: false, active: false),
  ];
  List<Milestone> get milestones => _milestones;

  int get completedCount => _milestones.where((m) => m.completed).length;
  int get totalCount => _milestones.length;
  double get progress => completedCount / totalCount;
  int get inProgressCount => _milestones.where((m) => m.active).length;
  int get upcomingCount => _milestones.where((m) => !m.completed && !m.active).length;

  void addMilestone(String title) {
    _milestones.add(Milestone(title: title, date: 'Expected: TBD', completed: false, active: false));
    notifyListeners();
  }
}
