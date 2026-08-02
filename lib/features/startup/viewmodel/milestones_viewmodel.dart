import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class MilestonesViewModel extends ChangeNotifier {
  final List<Milestone> _milestones = [
    const Milestone(
      title: 'Idea Created',
      date: 'Jan 15, 2023 • Initial ideation phase',
      completed: true,
      active: false,
      category: 'Ideation',
      description: 'Defined initial core problem statement and market research.',
      targetDate: 'Jan 15, 2023',
    ),
    const Milestone(
      title: 'Team Assembled',
      date: 'Feb 25, 2023 • Core engineering team hired',
      completed: true,
      active: false,
      category: 'Team & HR',
      description: 'Recrypted lead engineer, UI designer, and founding PM.',
      targetDate: 'Feb 25, 2023',
    ),
    const Milestone(
      title: 'Seed Funding Secured',
      date: 'May 10, 2023 • First \$50K from early VC',
      completed: true,
      active: false,
      category: 'Fundraising',
      description: 'Closed pre-seed angel tranche with 18 months runway.',
      targetDate: 'May 10, 2023',
    ),
    const Milestone(
      title: 'Beta Phase Started',
      date: 'Sep 4, 2023 • Feature complete, stability testing',
      completed: true,
      active: false,
      category: 'Product',
      description: 'Onboarded 50 pilot customers for closed testing.',
      targetDate: 'Sep 4, 2023',
    ),
    const Milestone(
      title: 'MVP Launched',
      date: 'In Progress • Feature complete, stability testing',
      completed: false,
      active: true,
      category: 'Product',
      description: 'Public production release on iOS and Android.',
      targetDate: 'Mar 15, 2024',
    ),
    const Milestone(
      title: 'First 1,000 Customers',
      date: 'Expected: June 2024',
      completed: false,
      active: false,
      category: 'Growth',
      description: 'Hit 1,000 active monthly subscription accounts.',
      targetDate: 'Jun 30, 2024',
    ),
    const Milestone(
      title: 'Series A Funding',
      date: 'Expected: Oct 2024',
      completed: false,
      active: false,
      category: 'Fundraising',
      description: 'Raise \$2M Series A for scale up.',
      targetDate: 'Oct 15, 2024',
    ),
  ];
  List<Milestone> get milestones => _milestones;

  int get completedCount => _milestones.where((m) => m.completed).length;
  int get totalCount => _milestones.length;
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;
  int get inProgressCount => _milestones.where((m) => m.active).length;
  int get upcomingCount => _milestones.where((m) => !m.completed && !m.active).length;

  void addMilestone({
    required String title,
    required String category,
    required String targetDate,
    required String status,
    String? description,
  }) {
    final isCompleted = status == 'Completed';
    final isActive = status == 'In Progress';
    final formattedDate = description != null && description.isNotEmpty
        ? '$targetDate • $description'
        : 'Expected: $targetDate';

    _milestones.add(Milestone(
      title: title,
      date: formattedDate,
      completed: isCompleted,
      active: isActive,
      category: category,
      description: description,
      targetDate: targetDate,
    ));
    notifyListeners();
  }
}
