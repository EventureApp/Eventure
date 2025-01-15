import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_event_type_select.dart';
import 'package:eventure/statics/event_types.dart';

void main() {
  testWidgets('EventSelect updates on selection', (WidgetTester tester) async {
    List<EventType> selectedEvents = [];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EventSelect(
          label: 'Events',
          initValues: const [],
          events: const {EventType.gaming: Icons.event},
          onChanged: (events) {
            selectedEvents = events;
          },
        ),
      ),
    ));

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    await tester.tap(find.text('conference'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(selectedEvents, [EventType.gaming]);
  });
}