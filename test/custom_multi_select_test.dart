import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_multi_select.dart';


void main() {
  group('MultiSelectDropdown Widget Tests', () {

    testWidgets('Shows error for required field when no selection is made', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectDropdown(
              label: 'Test Label',
              initValues: const [],
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (values) {},
              required: true,
              editable: true,
            ),
          ),
        ),
      );

      // Open the dropdown
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Close the dialog without selecting any options
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Verify the error message is displayed
      expect(find.text('At least one selection is required.'), findsOneWidget);
    });

    testWidgets('Allows selecting multiple options', (WidgetTester tester) async {
      List<String> selectedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectDropdown(
              label: 'Test Label',
              initValues: const [],
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (values) {
                selectedValues = values;
              },
              required: false,
              editable: true,
            ),
          ),
        ),
      );

      // Open the dropdown
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Select multiple options
      await tester.tap(find.text('Option 1').hitTestable());
      await tester.tap(find.text('Option 2').hitTestable());

      // Confirm selection
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Verify the selected values
      expect(selectedValues, ['Option 1', 'Option 2']);
      expect(find.text('Option 1, Option 2'), findsOneWidget);
    });

    testWidgets('Handles canceling selection', (WidgetTester tester) async {
      List<String> selectedValues = ['Option 1'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectDropdown(
              label: 'Test Label',
              initValues: selectedValues,
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (values) {
                selectedValues = values;
              },
              required: false,
              editable: true,
            ),
          ),
        ),
      );

      // Open the dropdown
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Attempt to deselect an option but cancel
      await tester.tap(find.text('Option 1').hitTestable());
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify the original selection remains unchanged
      expect(selectedValues, ['Option 1']);
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('Does not allow editing when editable is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectDropdown(
              label: 'Test Label',
              initValues: const [],
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (values) {},
              required: false,
              editable: false,
            ),
          ),
        ),
      );

      // Attempt to open the dropdown
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Verify the dialog does not open
      expect(find.text('Select Test Label'), findsNothing);
    });
  });
}
