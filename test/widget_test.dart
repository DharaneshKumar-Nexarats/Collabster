// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:collabsphere/main.dart';
import 'package:collabsphere/features/onboarding/view/onboarding_screen.dart';
import 'package:collabsphere/features/auth/model/auth_session.dart';
import 'package:collabsphere/features/auth/services/local_auth_storage.dart';

void main() {
  test(
    'startup profile details persist in the authenticated session',
    () async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalAuthStorage();
      await storage.saveSession(
        const AuthSession(
          fullName: 'Asha Rao',
          email: 'asha@example.com',
          password: 'secret',
          phone: '1234567890',
          role: 'Founder',
          onboardingComplete: false,
        ),
      );

      await storage.updateSession(
        (session) => session?.copyWith(
          startupName: 'Orbit Labs',
          startupIndustry: 'Climate Tech',
          startupStage: 'Seed',
          startupTagline: 'Clean energy for every home',
          startupCountry: 'India',
          startupCity: 'Bengaluru',
        ),
      );

      final session = await storage.readSession();
      expect(session?.startupName, 'Orbit Labs');
      expect(session?.startupIndustry, 'Climate Tech');
      expect(session?.startupStage, 'Seed');
      expect(session?.startupTagline, 'Clean energy for every home');
      expect(session?.startupCountry, 'India');
      expect(session?.startupCity, 'Bengaluru');
    },
  );

  testWidgets('app boots to onboarding', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
