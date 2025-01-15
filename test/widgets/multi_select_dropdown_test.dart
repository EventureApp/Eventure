import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_multi_select.dart';

void main() {
  testWidgets('MultiSelectDropdown updates on selection', (WidgetTester tester) async {
    List<String> selectedValues = [];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MultiSelectDropdown(
          label: 'Options',
          initValues: const [],
          data: const {'Option 1': 1, 'Option 2': 2},
          onChanged: (values) {
            selectedValues = values;
          },
          required: true,
          editable: true,
        ),
      ),
    ));

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Option 1'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(selectedValues, ['Option 1']);
  });
}