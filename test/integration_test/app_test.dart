import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eventure/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Teste die Erstellung eines neuen Events
    final addIconFinder = find.byIcon(Icons.add);
    expect(addIconFinder, findsOneWidget);

    await tester.tap(addIconFinder);
    await tester.pumpAndSettle();

    final eventNameField = find.byKey(Key('eventName'));
    expect(eventNameField, findsOneWidget);

    await tester.enterText(eventNameField, 'Test Event');
    await tester.tap(find.byKey(Key('saveEvent')));
    await tester.pumpAndSettle();

    expect(find.text('Event successfully saved!'), findsOneWidget);
  });
}