import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom-single-select.dart';

void main() {
  group('SingleSelectDropdown Widget Tests', () {
    late String? selectedValue;

    setUp(() {
      selectedValue = null;
    });

    testWidgets('Displays label with mandatory asterisk when required', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleSelectDropdown(
            label: 'Category',
            data: {'Option 1': true, 'Option 2': true},
            onChanged: (value) {},
            required: true,
            editable: true,
          ),
        ),
      ));

      // Debug-Ausgabe der sichtbaren Text-Widgets
      final textWidgets = find.byType(Text);
      for (final element in textWidgets.evaluate()) {
        final textWidget = element.widget as Text;
        debugPrint('Found Text widget: "${textWidget.data}"');
      }

      // Prüfen, ob das Label "CATEGORY" angezeigt wird
      expect(find.text('CATEGORY'), findsOneWidget);

      // Prüfen, ob das Sternchen "*" separat angezeigt wird
      expect(find.text(' *'), findsOneWidget);
    });

    testWidgets('Allows selecting an option', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleSelectDropdown(
            label: 'Category',
            data: {'Option 1': true, 'Option 2': true},
            onChanged: (value) => selectedValue = value,
            required: false,
            editable: true,
          ),
        ),
      ));

      // Öffne das Dropdown
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Wähle "Option 1" aus
      await tester.tap(find.text('Option 1').hitTestable());
      await tester.pumpAndSettle();

      // Prüfen, ob der Wert übernommen wurde
      expect(selectedValue, 'Option 1');
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('Dropdown is not editable when editable is false', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleSelectDropdown(
            label: 'Category',
            data: {'Option 1': true, 'Option 2': true},
            onChanged: (value) => selectedValue = value,
            required: false,
            editable: false,
          ),
        ),
      ));

      // Tippe auf das Dropdown
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Stelle sicher, dass der Dialog NICHT erscheint
      expect(find.text('Select CATEGORY'), findsNothing);
    });

    testWidgets('Initial value is displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleSelectDropdown(
            label: 'Category',
            initValue: 'Option 2',
            data: {'Option 1': true, 'Option 2': true},
            onChanged: (value) => selectedValue = value,
            required: false,
            editable: true,
          ),
        ),
      ));

      // Prüfe, ob der Initialwert korrekt angezeigt wird
      expect(find.text('Option 2'), findsOneWidget);
    });
  });
}
