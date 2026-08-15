import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collabsphere/core/theme/app_theme.dart';
import 'package:collabsphere/features/event/view/screens/events/conferences_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/event_detail_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/event_home_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/meetups_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/my_events_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/webinars_screen.dart';
import 'package:collabsphere/features/event/view/screens/events/workshops_screen.dart';
import 'package:collabsphere/features/event/model/event_model.dart';

void main() {
  Future<void> pumpThemed(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.lightTheme, home: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('EventHome + category nav with real theme', (tester) async {
    await pumpThemed(tester, const EventHomeScreen());
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Conferences'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Conferences'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'crash navigating to conferences');
    expect(find.text('Future of AI 2024'), findsOneWidget);
  });

  testWidgets('EventDetailScreen with real theme', (tester) async {
    final event = Event(
      id: '1',
      title: 'Test Conference',
      description: 'Desc',
      location: 'Bangalore',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 31)),
      organizerName: 'Team',
      category: 'Conference',
      attendeeCount: 10,
    );
    await pumpThemed(tester, EventDetailScreen(event: event));
    expect(tester.takeException(), isNull);
  });

  testWidgets('MyEventsScreen with real theme', (tester) async {
    await pumpThemed(tester, const MyEventsScreen());
    expect(tester.takeException(), isNull);
  });

  testWidgets('ConferencesScreen direct with real theme', (tester) async {
    await pumpThemed(tester, const ConferencesScreen());
    expect(tester.takeException(), isNull);
  });

  testWidgets('WorkshopsScreen direct with real theme', (tester) async {
    await pumpThemed(tester, const WorkshopsScreen());
    expect(tester.takeException(), isNull);
  });

  testWidgets('MeetupsScreen direct with real theme', (tester) async {
    await pumpThemed(tester, const MeetupsScreen());
    expect(tester.takeException(), isNull);
  });

  testWidgets('WebinarsScreen direct with real theme', (tester) async {
    await pumpThemed(tester, const WebinarsScreen());
    expect(tester.takeException(), isNull);
  });
}

