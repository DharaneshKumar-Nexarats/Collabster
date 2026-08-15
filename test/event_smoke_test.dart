import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collabsphere/features/event/view/screens/events/conferences_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/event_create_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/event_home_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/hackathons_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/meetups_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/webinars_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/workshops_screen.dart';
import 'package:collabsphere/features/event/view/screens/event_home_screen.dart'
    as legacy;

void main() {
  Future<void> pumpPhone(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: child),
      ),
    );
  }

  Future<void> pumpPhoneLoaded(WidgetTester tester, Widget child) async {
    await pumpPhone(tester, child);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('ConferencesScreen builds on phone size', (tester) async {
    await pumpPhoneLoaded(tester, const ConferencesScreen());
    expect(find.text('Conferences'), findsOneWidget);
  });

  testWidgets('HackathonsScreen builds on phone size', (tester) async {
    await pumpPhoneLoaded(tester, const HackathonsScreen());
  });

  testWidgets('MeetupsScreen builds on phone size', (tester) async {
    await pumpPhoneLoaded(tester, const MeetupsScreen());
  });

  testWidgets('WorkshopsScreen builds on phone size', (tester) async {
    await pumpPhoneLoaded(tester, const WorkshopsScreen());
  });

  testWidgets('WebinarsScreen builds on phone size', (tester) async {
    await pumpPhoneLoaded(tester, const WebinarsScreen());
  });

  testWidgets('EventHomeScreen builds on phone size', (tester) async {
    await pumpPhoneLoaded(tester, const EventHomeScreen());
  });

  testWidgets('Tapping Conferences chip opens ConferencesScreen',
      (tester) async {
    await pumpPhoneLoaded(tester, const EventHomeScreen());
    await tester.scrollUntilVisible(
      find.text('Conferences'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Conferences'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Future of AI 2024'), findsOneWidget);
  });

  testWidgets('EventsListScreen loads and builds on phone size',
      (tester) async {
    await pumpPhone(tester, const legacy.EventsListScreen());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('EventCreateScreen builds on phone size', (tester) async {
    await pumpPhoneLoaded(tester, const EventCreateScreen());
    expect(find.text('Publish Event'), findsOneWidget);
  });

  testWidgets('EventCreateScreen shows validation when required fields are missing',
      (tester) async {
    await pumpPhoneLoaded(tester, const EventCreateScreen());
    await tester.tap(find.text('Publish Event'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an event title'), findsOneWidget);
    expect(find.text('Write a short description'), findsOneWidget);
    expect(find.text('Pick start and end dates'), findsOneWidget);
  });
}