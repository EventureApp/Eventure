import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_discription_input.dart';

void main() {
  testWidgets('CustomDescriptionInput updates on text input', (WidgetTester tester) async {
    String description = '';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomDescriptionInput(
          label: 'Description',
          required: true,
          editable: true,
          onChanged: (value) {
            description = value;
          },
        ),
      ),
    ));

    await tester.enterText(find.byType(TextField), 'New description');
    await tester.pump();

    expect(description, 'New description');
  });
}