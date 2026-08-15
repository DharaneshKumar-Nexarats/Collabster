import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:collabsphere/features/investor/investor.dart';

void main() {
  testWidgets('InvestorHomeScreen renders header and bottom nav', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: InvestorHomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Investor Hub'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Portfolio'), findsWidgets);
    expect(find.text('Discover'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });

  testWidgets('InvestorProfileScreen renders tabs and preferences', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: InvestorProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Investor Hub'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('PitchDeckScreen renders search and pitch decks', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PitchDeckScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Pitch Decks'), findsOneWidget);
    expect(find.text('DECKS RECEIVED'), findsOneWidget);
  });
}
