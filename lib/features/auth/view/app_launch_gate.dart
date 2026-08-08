import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/dashboard_router.dart';
import '../../onboarding/view/onboarding_screen.dart';
import '../../../core/di/providers.dart';

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
    _initFuture = Future<void>(_resolveDestination);
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

        return buildDashboardForRole(authState.session!);
      },
    );
  }
}
