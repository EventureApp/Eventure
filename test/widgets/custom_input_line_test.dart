import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_input_line.dart';

void main() {
  testWidgets('CustomInputLine updates on text input', (WidgetTester tester) async {
    String inputText = '';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomInputLine(
          label: 'Input',
          required: true,
          editable: true,
          onChanged: (value) {
            inputText = value;
          },
        ),
      ),
    ));

    await tester.enterText(find.byType(TextField), 'New input');
    await tester.pump();

    expect(inputText, 'New input');
  });
}