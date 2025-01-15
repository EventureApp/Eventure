import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_date_time_picker.dart';

void main() {
  testWidgets('CustomDateAndTimePicker displays initial value and updates on selection', (WidgetTester tester) async {
    DateTime selectedDate = DateTime(2023, 1, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomDateAndTimePicker(
            label: 'Date',
            required: true,
            editable: true,
            onDateChanged: (date) {},
          ),
        ),
      ),
    );

    expect(find.text('Date'), findsOneWidget);
    expect(find.text('01/01/2023'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(selectedDate.day, 15);
  });
}