import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'join_startup_state.dart';

class JoinStartupViewModel extends StateNotifier<JoinStartupState> {
  JoinStartupViewModel() : super(const JoinStartupState());

  void loadInitialData() {
    state = state.copyWith(
      suggestedStartups: const [
        SuggestedStartup(
          name: 'NexusAI',
          industry: 'Artificial Intelligence',
          location: 'San Francisco',
          teamMembers: 48,
          stage: 'Series A',
          tags: ['AI', 'SAAS'],
          tagline: 'AI-powered analytics for enterprises',
          description: 'NexusAI provides cutting-edge artificial intelligence solutions for enterprise data analytics.',
          problem: 'Enterprises struggle with processing and analyzing large volumes of data efficiently.',
          solution: 'Our AI engine processes data 10x faster than traditional methods.',
          mission: 'Democratize AI-powered analytics for businesses of all sizes.',
          vision: 'A world where every business decision is backed by intelligent data analysis.',
          website: 'nexusai.com',
          founderName: 'Sarah Chen',
          incorporationDate: '2022-03-15',
        ),
        SuggestedStartup(
          name: 'FlowPay',
          industry: 'Fintech',
          location: 'London',
          teamMembers: 124,
          stage: 'Seed',
          tags: ['FINTECH', 'PAYMENTS'],
          tagline: 'Next-gen payment infrastructure',
          description: 'FlowPay is building the future of digital payments.',
          problem: 'Cross-border payments are slow, expensive, and unreliable.',
          solution: 'Blockchain-powered payment rails that settle in seconds.',
          mission: 'Make global payments free and instant for everyone.',
          vision: 'A world without payment borders.',
          website: 'flowpay.io',
          founderName: 'James Wilson',
          incorporationDate: '2023-01-20',
        ),
        SuggestedStartup(
          name: 'VitaLife',
          industry: 'HealthTech',
          location: 'Berlin',
          teamMembers: 32,
          stage: 'Pre-Seed',
          tags: ['HEALTHTECH', 'AI'],
          tagline: 'AI-driven personalized wellness',
          description: 'VitaLife uses AI to create personalized health plans.',
          problem: 'Generic health advice fails to account for individual differences.',
          solution: 'AI-powered platform that analyzes individual health data.',
          mission: 'Empower individuals to take control of their health.',
          vision: 'A world where preventive healthcare is accessible to all.',
          website: 'vitalife.health',
          founderName: 'Anna Müller',
          incorporationDate: '2023-06-10',
        ),
        SuggestedStartup(
          name: 'MedVision AI',
          industry: 'Medical AI',
          location: 'San Francisco',
          teamMembers: 48,
          stage: 'Series A',
          tags: ['HEALTHTECH', 'SAAS', 'DIAGNOSTICS'],
          tagline: 'AI diagnostics for faster, better care',
          description: 'MedVision AI develops medical imaging AI.',
          problem: 'Radiologists are overworked, leading to diagnostic delays.',
          solution: 'AI copilot that pre-screens medical images.',
          mission: 'Accelerate diagnosis and improve patient outcomes.',
          vision: 'Every patient gets a fast, accurate diagnosis.',
          website: 'medvision.ai',
          founderName: 'Dr. Raj Patel',
          incorporationDate: '2022-09-01',
        ),
      ],
    );
  }

  void selectMode(String mode) {
    state = state.copyWith(selectedMode: mode);
  }

  List<SuggestedStartup> filterStartups(String query, [List<SuggestedStartup>? source]) {
    final list = source ?? state.suggestedStartups;
    if (query.isEmpty) return list;
    final q = query.toLowerCase();
    switch (state.selectedMode) {
      case 'Industry':
        return list.where((s) =>
            s.industry.toLowerCase().contains(q) ||
            s.tags.any((t) => t.toLowerCase().contains(q))).toList();
      case 'Location':
        return list.where((s) =>
            s.location.toLowerCase().contains(q)).toList();
      case 'Stage':
        return list.where((s) =>
            s.stage.toLowerCase().contains(q)).toList();
      default:
        return list.where((s) {
          return s.name.toLowerCase().contains(q) ||
              s.industry.toLowerCase().contains(q) ||
              s.location.toLowerCase().contains(q) ||
              s.tags.any((t) => t.toLowerCase().contains(q));
        }).toList();
    }
  }
}
