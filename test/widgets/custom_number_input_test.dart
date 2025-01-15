import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_number_select.dart';

void main() {
  testWidgets('CustomNumberInput updates on valid number input', (WidgetTester tester) async {
    int? number;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomNumberInput(
          label: 'Number',
          onChanged: (value) {
            number = value;
          },
        ),
      ),
    ));

    await tester.enterText(find.byType(TextField), '42');
    await tester.pump();

    expect(number, 42);
  });
}