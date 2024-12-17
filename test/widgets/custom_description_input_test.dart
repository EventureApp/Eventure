import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_discription_input.dart';

void main() {
  group('CustomDescriptionInput Widget Tests', () {
    late String inputValue;

    setUp(() {
      inputValue = '';
    });

    testWidgets('Displays label with mandatory asterisk when required', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomDescriptionInput(
            label: 'Description',
            required: true,
            editable: true,
            onChanged: (value) => inputValue = value,
          ),
        ),
      ));

      // Prüfe, ob das Label mit Sternchen angezeigt wird
      expect(find.text('DESCRIPTION *'), findsOneWidget);

      // Prüfe, ob der Platzhalter für ein Pflichtfeld angezeigt wird
      expect(find.text('Madatory'), findsOneWidget);
    });

    testWidgets('Does not allow editing when editable is false', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomDescriptionInput(
            label: 'Description',
            required: false,
            editable: false, // Bearbeitung deaktiviert
            onChanged: (value) => inputValue = value,
          ),
        ),
      ));

      // Eingabefeld prüfen
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'Test Input');
      await tester.pump();

      // Sicherstellen, dass der Text NICHT übernommen wird
      expect(inputValue, ''); // Der Callback sollte nicht ausgelöst werden
    });

    testWidgets('Calls onChanged callback with correct value', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomDescriptionInput(
            label: 'Description',
            required: false,
            editable: true,
            onChanged: (value) => inputValue = value,
          ),
        ),
      ));

      // Text eingeben
      await tester.enterText(find.byType(TextFormField), 'Hello World');
      await tester.pump();

      // Sicherstellen, dass der Callback den richtigen Wert liefert
      expect(inputValue, 'Hello World');
    });
  });
}
