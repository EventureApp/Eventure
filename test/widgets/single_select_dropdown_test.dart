import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_single_select.dart';

void main() {
  testWidgets('SingleSelectDropdown updates on selection', (WidgetTester tester) async {
    String? selectedValue;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleSelectDropdown(
          label: 'Options',
          data: const {'Option 1': 1, 'Option 2': 2},
          onChanged: (value) {
            selectedValue = value;
          },
          required: true,
          editable: true,
        ),
      ),
    ));

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    expect(selectedValue, 'Option 1');
  });
}