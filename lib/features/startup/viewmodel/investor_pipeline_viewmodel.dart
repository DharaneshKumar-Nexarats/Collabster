import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class InvestorPipelineViewModel extends ChangeNotifier {
  final List<InvestorEntry> _investors = const [
    InvestorEntry(name: 'Vertex Capital', fund: 'Series A', amount: '\$350K', status: 'Tomorrow', statusColor: Color(0xFF5B21B6), initials: 'VC', color: Color(0xFF4F46E5), contacted: 6, replied: 4),
    InvestorEntry(name: 'NorthStar Ventures', fund: 'Pre-Seed', amount: '\$400K', status: 'Not Engaged', statusColor: Color(0xFF9CA3AF), initials: 'NV', color: Color(0xFF0D9488), contacted: 4, replied: 2),
    InvestorEntry(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', status: '2 weeks ago', statusColor: Color(0xFF6B7280), initials: 'SF', color: Color(0xFFF59E0B), contacted: 8, replied: 8),
    InvestorEntry(name: 'TechWave Fund', fund: 'Series A', amount: '\$500K', status: 'Active', statusColor: Color(0xFF059669), initials: 'TW', color: Color(0xFF2563EB), contacted: 3, replied: 2),
  ];
  List<InvestorEntry> get investors => _investors;
}
