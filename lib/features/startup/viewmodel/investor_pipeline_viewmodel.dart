import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'investor_pipeline_state.dart';

class InvestorPipelineViewModel extends StateNotifier<InvestorPipelineState> {
  InvestorPipelineViewModel() : super(const InvestorPipelineState());

  void loadInitialData() {
    state = state.copyWith(
      discoverInvestors: const [
        InvestorEntry(name: 'Vertex Capital', fund: 'Series A', amount: '\$350K', status: 'Tomorrow', statusColorKey: 'primary', initials: 'VC', colorKey: 'indigo', contacted: 6, replied: 4),
        InvestorEntry(name: 'NorthStar Ventures', fund: 'Pre-Seed', amount: '\$400K', status: 'Not Engaged', statusColorKey: 'muted', initials: 'NV', colorKey: 'teal', contacted: 4, replied: 2),
        InvestorEntry(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', status: '2 weeks ago', statusColorKey: 'draft', initials: 'SF', colorKey: 'amber', contacted: 8, replied: 8),
        InvestorEntry(name: 'TechWave Fund', fund: 'Series A', amount: '\$500K', status: 'Active', statusColorKey: 'live', initials: 'TW', colorKey: 'blue', contacted: 3, replied: 2),
        InvestorEntry(name: 'Horizon Ventures', fund: 'Series A', amount: '\$350K', status: 'Meeting Tomorrow', statusColorKey: 'primary', initials: 'HV', colorKey: 'purple', contacted: 5, replied: 5),
      ],
      pipelineInvestors: const [
        InvestorEntry(name: 'Horizon Ventures', fund: 'Series A', amount: '\$350K', status: 'Meeting Tomorrow', statusColorKey: 'primary', initials: 'HV', colorKey: 'purple', contacted: 5, replied: 5),
        InvestorEntry(name: 'Vertex Capital', fund: 'Series A', amount: '\$350K', status: 'Tomorrow', statusColorKey: 'primary', initials: 'VC', colorKey: 'indigo', contacted: 6, replied: 4),
        InvestorEntry(name: 'TechWave Fund', fund: 'Series A', amount: '\$500K', status: 'Active', statusColorKey: 'live', initials: 'TW', colorKey: 'blue', contacted: 3, replied: 2),
      ],
      savedInvestors: const [
        InvestorEntry(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', status: 'Saved', statusColorKey: 'draft', initials: 'SF', colorKey: 'amber', contacted: 8, replied: 8),
      ],
    );
  }

  void saveInvestor(InvestorEntry investor) {
    if (!state.isSaved(investor.name)) {
      state = state.copyWith(savedInvestors: [investor, ...state.savedInvestors]);
    }
  }

  void unsaveInvestor(String name) {
    final updated = state.savedInvestors.where((i) => i.name != name).toList();
    state = state.copyWith(savedInvestors: updated);
  }

  void removeInvestor(String name) {
    state = state.copyWith(
      discoverInvestors: state.discoverInvestors.where((i) => i.name != name).toList(),
      pipelineInvestors: state.pipelineInvestors.where((i) => i.name != name).toList(),
      savedInvestors: state.savedInvestors.where((i) => i.name != name).toList(),
    );
  }

  void addInvestor(InvestorEntry investor) {
    state = state.copyWith(
      discoverInvestors: [investor, ...state.discoverInvestors],
      pipelineInvestors: [investor, ...state.pipelineInvestors],
    );
  }

  List<InvestorEntry> filterList(List<InvestorEntry> source, String query) {
    if (query.isEmpty) return source;
    final q = query.toLowerCase();
    return source.where((i) => i.name.toLowerCase().contains(q) || i.fund.toLowerCase().contains(q)).toList();
  }
}
