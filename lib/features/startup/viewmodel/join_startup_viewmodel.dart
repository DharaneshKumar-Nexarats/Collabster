import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class JoinStartupViewModel extends ChangeNotifier {
  String _selectedMode = 'Startup Name';
  String get selectedMode => _selectedMode;

  final List<SuggestedStartup> _suggestedStartups = const [
    SuggestedStartup(
      name: 'NexusAI',
      industry: 'Artificial Intelligence',
      location: 'San Francisco',
      teamMembers: 48,
      stage: 'Series A',
      tags: ['AI', 'SAAS'],
      tagline: 'AI-powered analytics for enterprises',
      description: 'NexusAI provides cutting-edge artificial intelligence solutions for enterprise data analytics. Our platform helps companies make data-driven decisions with real-time insights.',
      problem: 'Enterprises struggle with processing and analyzing large volumes of data efficiently.',
      solution: 'Our AI engine processes data 10x faster than traditional methods, providing actionable insights in real-time.',
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
      description: 'FlowPay is building the future of digital payments. Our platform enables seamless cross-border transactions with zero fees for consumers.',
      problem: 'Cross-border payments are slow, expensive, and unreliable for both businesses and consumers.',
      solution: 'Blockchain-powered payment rails that settle in seconds with minimal fees.',
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
      description: 'VitaLife uses AI to create personalized health plans based on your genetics, lifestyle, and goals.',
      problem: 'Generic health advice fails to account for individual differences in genetics and lifestyle.',
      solution: 'AI-powered platform that analyzes individual health data to create truly personalized wellness plans.',
      mission: 'Empower individuals to take control of their health with personalized insights.',
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
      description: 'MedVision AI develops medical imaging AI that assists doctors in diagnosing diseases faster and more accurately.',
      problem: 'Radiologists are overworked, leading to diagnostic delays and errors.',
      solution: 'AI copilot that pre-screens medical images and flags potential issues for radiologist review.',
      mission: 'Accelerate diagnosis and improve patient outcomes through AI assistance.',
      vision: 'Every patient gets a fast, accurate diagnosis.',
      website: 'medvision.ai',
      founderName: 'Dr. Raj Patel',
      incorporationDate: '2022-09-01',
    ),
  ];
  List<SuggestedStartup> get suggestedStartups => _suggestedStartups;

  void selectMode(String mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  List<SuggestedStartup> filterStartups(String query, [List<SuggestedStartup>? source]) {
    final list = source ?? _suggestedStartups;
    if (query.isEmpty) return list;
    final q = query.toLowerCase();
    switch (_selectedMode) {
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
      default: // Startup Name
        return list.where((s) {
          return s.name.toLowerCase().contains(q) ||
              s.industry.toLowerCase().contains(q) ||
              s.location.toLowerCase().contains(q) ||
              s.tags.any((t) => t.toLowerCase().contains(q));
        }).toList();
    }
  }
}
