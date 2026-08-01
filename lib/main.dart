import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/view/app_launch_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const AppLaunchGate(),
    );
  }
}
