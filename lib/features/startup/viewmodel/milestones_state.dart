import '../model/startup_models.dart';

class MilestonesState {
  const MilestonesState({
    this.milestones = const [],
    this.selectedCategory = 'All',
  });

  final List<Milestone> milestones;
  final String selectedCategory;

  int get completedCount => milestones.where((m) => m.completed).length;
  int get totalCount => milestones.length;
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;
  int get inProgressCount => milestones.where((m) => m.active).length;
  int get upcomingCount => milestones.where((m) => !m.completed && !m.active).length;

  MilestonesState copyWith({
    List<Milestone>? milestones,
    String? selectedCategory,
  }) {
    return MilestonesState(
      milestones: milestones ?? this.milestones,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
