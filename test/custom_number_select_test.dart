import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_number_select.dart';

void main() {
  group('CustomNumberInput Widget Tests', () {
    testWidgets('Initial state is displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNumberInput(
              label: 'Test Label',
              hint: 'Enter a number',
              isMandatory: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Verify the label and hint text are displayed
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Enter a number'), findsOneWidget);

      // Verify no error message is displayed initially
      expect(find.text('This field is mandatory.'), findsNothing);
    });

    testWidgets('Displays error for invalid number input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNumberInput(
              label: 'Test Label',
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Enter invalid input
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pumpAndSettle();

      // Verify the error message is displayed
      expect(find.text('Please enter a valid number.'), findsOneWidget);
    });

    testWidgets('Displays error for value below minValue', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNumberInput(
              label: 'Test Label',
              minValue: 10,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Enter a value below the minimum
      await tester.enterText(find.byType(TextField), '5');
      await tester.pumpAndSettle();

      // Verify the error message is displayed
      expect(find.text('Value must be >= 10.'), findsOneWidget);
    });

    testWidgets('Displays error for value above maxValue', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNumberInput(
              label: 'Test Label',
              maxValue: 100,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Enter a value above the maximum
      await tester.enterText(find.byType(TextField), '150');
      await tester.pumpAndSettle();

      // Verify the error message is displayed
      expect(find.text('Value must be <= 100.'), findsOneWidget);
    });

    testWidgets('Valid input updates the value and clears error', (WidgetTester tester) async {
      int? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNumberInput(
              label: 'Test Label',
              minValue: 10,
              maxValue: 100,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      // Enter a valid value
      await tester.enterText(find.byType(TextField), '50');
      await tester.pumpAndSettle();

      // Verify no error message is displayed
      expect(find.textContaining('Value must be'), findsNothing);

      // Verify the onChanged callback is triggered with the correct value
      expect(changedValue, 50);
    });
  });
}
