import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_single_select.dart';


void main() {
  group('SingleSelectDropdown Widget Tests', () {
    testWidgets('Initial state is displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleSelectDropdown(
              label: 'Test Label',
              initValue: null,
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (value) {},
              required: false,
              editable: true,
            ),
          ),
        ),
      );

      // Verify the label is displayed
      expect(find.text('Test Label'), findsOneWidget);

      // Verify the hint text is displayed
      expect(find.text('Optional'), findsOneWidget);

      // Verify the dropdown icon is present
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('Required field displays error when empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleSelectDropdown(
              label: 'Test Label',
              initValue: null,
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (value) {},
              required: true,
              editable: true,
            ),
          ),
        ),
      );

      // Open the dropdown
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Close the dialog without selecting an option
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('This field is required.'), findsOneWidget);
    });

    testWidgets('Editable dropdown opens dialog with options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleSelectDropdown(
              label: 'Test Label',
              initValue: null,
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (value) {},
              required: false,
              editable: true,
            ),
          ),
        ),
      );

      // Open the dropdown
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Select Test Label'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('Selecting an option updates the value', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleSelectDropdown(
              label: 'Test Label',
              initValue: null,
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (value) {
                selectedValue = value;
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

      // Select an option
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Verify the value is updated
      expect(selectedValue, 'Option 1');
    });

    testWidgets('Non-editable dropdown does not open dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleSelectDropdown(
              label: 'Test Label',
              initValue: null,
              data: const {'Option 1': 1, 'Option 2': 2},
              onChanged: (value) {},
              required: false,
              editable: false,
            ),
          ),
        ),
      );

      // Try to open the dropdown
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Verify no dialog is shown
      expect(find.text('Select Test Label'), findsNothing);
    });
  });
}
