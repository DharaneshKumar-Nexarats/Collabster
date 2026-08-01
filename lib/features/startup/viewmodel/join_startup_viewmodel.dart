import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class JoinStartupViewModel extends ChangeNotifier {
  String _selectedMode = 'Startup Name';
  String get selectedMode => _selectedMode;

  final List<SuggestedStartup> _suggestedStartups = const [
    SuggestedStartup(name: 'NexusAI', industry: 'Artificial Intelligence', location: 'San Francisco', teamMembers: 48, stage: 'Series A', tags: ['AI', 'SAAS']),
    SuggestedStartup(name: 'FlowPay', industry: 'Fintech', location: 'London', teamMembers: 124, stage: 'Seed', tags: ['FINTECH', 'PAYMENTS']),
    SuggestedStartup(name: 'VitaLife', industry: 'HealthTech', location: 'Berlin', teamMembers: 32, stage: 'Pre-Seed', tags: ['HEALTHTECH', 'AI']),
    SuggestedStartup(name: 'MedVision AI', industry: 'Medical AI', location: 'San Francisco', teamMembers: 48, stage: 'Series A', tags: ['HEALTHTECH', 'SAAS', 'DIAGNOSTICS']),
  ];
  List<SuggestedStartup> get suggestedStartups => _suggestedStartups;

  void selectMode(String mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  List<SuggestedStartup> filterStartups(String query) {
    if (query.isEmpty) return _suggestedStartups;
    final q = query.toLowerCase();
    return _suggestedStartups.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.industry.toLowerCase().contains(q) ||
          s.location.toLowerCase().contains(q);
    }).toList();
  }
}
