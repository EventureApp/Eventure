import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom-event-select.dart';
import 'package:eventure/statics/event_types.dart';

void main() {
  group('EventSelect Widget Tests', () {
    late List<EventType> selectedEvents;

    setUp(() {
      selectedEvents = [];
    });

    testWidgets('Displays label and allows single selection', (WidgetTester tester) async {
      final testEvents = {
        EventType.concert: Icons.music_note,
        EventType.party: Icons.local_bar,
      };

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventSelect(
            label: 'Event Selection',
            initValues: [],
            events: testEvents,
            isMultiSelect: false,
            onChanged: (values) => selectedEvents = values,
          ),
        ),
      ));

      expect(find.text('Event Selection'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add)); // Öffnet das Popover
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.music_note)); // Wählt Konzert aus
      await tester.pumpAndSettle();

      expect(selectedEvents, [EventType.concert]);
    });

    testWidgets('Allows multi-selection', (WidgetTester tester) async {
      final testEvents = {
        EventType.concert: Icons.music_note,
        EventType.party: Icons.local_bar,
      };

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventSelect(
            label: 'Select Multiple Events',
            initValues: [],
            events: testEvents,
            isMultiSelect: true,
            onChanged: (values) => selectedEvents = values,
          ),
        ),
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.music_note));
      await tester.tap(find.byIcon(Icons.local_bar));
      await tester.pumpAndSettle();

      expect(selectedEvents, [EventType.concert, EventType.party]);
    });

    testWidgets('Disables interaction when not editable', (WidgetTester tester) async {
      final testEvents = {
        EventType.concert: Icons.music_note,
      };

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventSelect(
            label: 'Non-Editable Event Selection',
            initValues: [],
            events: testEvents,
            isEditable: false,
            onChanged: (values) => selectedEvents = values,
          ),
        ),
      ));

      expect(find.byIcon(Icons.add), findsNothing);
    });
  });
}
