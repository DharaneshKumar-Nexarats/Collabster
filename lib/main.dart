import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/views/onboarding_screen.dart';

void main() {
  runApp(
    // Added ProviderScope since the app uses Riverpod for state management
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollabSphere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Set the OnboardingScreen as the initial route
      home: const OnboardingScreen(),
    );
  }
}
