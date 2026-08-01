import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/view/home_screen.dart';
import '../../startup/view/screens/startup_dashboard_screen.dart';
import '../../startup/view/screens/startup_landing_screen.dart';
import '../../onboarding/view/onboarding_screen.dart';
import '../viewmodel/auth_viewmodel.dart';

class AppLaunchGate extends ConsumerStatefulWidget {
  const AppLaunchGate({super.key});

  @override
  ConsumerState<AppLaunchGate> createState() => _AppLaunchGateState();
}

class _AppLaunchGateState extends ConsumerState<AppLaunchGate> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _resolveDestination();
  }

  Future<void> _resolveDestination() async {
    await ref.read(authViewModelProvider.notifier).loadSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final authState = ref.watch(authViewModelProvider);

        if (authState.session == null) {
          return const OnboardingScreen();
        }

        final session = authState.session!;
        if (session.isStartupRole) {
          if (session.startupName != null && session.startupName!.isNotEmpty) {
            return StartupDashboardScreen(startupName: session.startupName!);
          }
          return StartupLandingScreen(selectedRole: session.role);
        }

        return const HomeScreen();
      },
    );
  }
}
