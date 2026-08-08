import 'package:flutter/foundation.dart';
import '../model/startup_models.dart';

class InvestorPipelineViewModel extends ChangeNotifier {
  final List<InvestorEntry> _discoverInvestors = [
    const InvestorEntry(name: 'Vertex Capital', fund: 'Series A', amount: '\$350K', status: 'Tomorrow', statusColorKey: 'primary', initials: 'VC', colorKey: 'indigo', contacted: 6, replied: 4),
    const InvestorEntry(name: 'NorthStar Ventures', fund: 'Pre-Seed', amount: '\$400K', status: 'Not Engaged', statusColorKey: 'muted', initials: 'NV', colorKey: 'teal', contacted: 4, replied: 2),
    const InvestorEntry(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', status: '2 weeks ago', statusColorKey: 'draft', initials: 'SF', colorKey: 'amber', contacted: 8, replied: 8),
    const InvestorEntry(name: 'TechWave Fund', fund: 'Series A', amount: '\$500K', status: 'Active', statusColorKey: 'live', initials: 'TW', colorKey: 'blue', contacted: 3, replied: 2),
    const InvestorEntry(name: 'Horizon Ventures', fund: 'Series A', amount: '\$350K', status: 'Meeting Tomorrow', statusColorKey: 'primary', initials: 'HV', colorKey: 'purple', contacted: 5, replied: 5),
  ];
  List<InvestorEntry> get discoverInvestors => List.unmodifiable(_discoverInvestors);

  final List<InvestorEntry> _pipelineInvestors = [
    const InvestorEntry(name: 'Horizon Ventures', fund: 'Series A', amount: '\$350K', status: 'Meeting Tomorrow', statusColorKey: 'primary', initials: 'HV', colorKey: 'purple', contacted: 5, replied: 5),
    const InvestorEntry(name: 'Vertex Capital', fund: 'Series A', amount: '\$350K', status: 'Tomorrow', statusColorKey: 'primary', initials: 'VC', colorKey: 'indigo', contacted: 6, replied: 4),
    const InvestorEntry(name: 'TechWave Fund', fund: 'Series A', amount: '\$500K', status: 'Active', statusColorKey: 'live', initials: 'TW', colorKey: 'blue', contacted: 3, replied: 2),
  ];
  List<InvestorEntry> get pipelineInvestors => List.unmodifiable(_pipelineInvestors);

  final List<InvestorEntry> _savedInvestors = [
    const InvestorEntry(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', status: 'Saved', statusColorKey: 'draft', initials: 'SF', colorKey: 'amber', contacted: 8, replied: 8),
  ];
  List<InvestorEntry> get savedInvestors => List.unmodifiable(_savedInvestors);

  bool isSaved(String name) => _savedInvestors.any((i) => i.name == name);

  void saveInvestor(InvestorEntry investor) {
    if (!_savedInvestors.any((i) => i.name == investor.name)) {
      _savedInvestors.add(investor);
      notifyListeners();
    }
  }

  void unsaveInvestor(String name) {
    _savedInvestors.removeWhere((i) => i.name == name);
    notifyListeners();
  }

  void removeInvestor(String name) {
    _discoverInvestors.removeWhere((i) => i.name == name);
    _pipelineInvestors.removeWhere((i) => i.name == name);
    _savedInvestors.removeWhere((i) => i.name == name);
    notifyListeners();
  }

  void addInvestor(InvestorEntry investor) {
    _discoverInvestors.insert(0, investor);
    _pipelineInvestors.insert(0, investor);
    notifyListeners();
  }

  List<InvestorEntry> filterList(List<InvestorEntry> source, String query) {
    if (query.isEmpty) return source;
    final q = query.toLowerCase();
    return source.where((i) => i.name.toLowerCase().contains(q) || i.fund.toLowerCase().contains(q)).toList();
  }
}
