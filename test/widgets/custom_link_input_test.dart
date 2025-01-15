import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/widgets/inputs/custom_link_select.dart';

void main() {
  testWidgets('CustomLinkInput updates on valid URL input', (WidgetTester tester) async {
    String? link;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomLinkInput(
          label: 'Link',
          onChanged: (value) {
            link = value;
          },
        ),
      ),
    ));

    await tester.enterText(find.byType(TextField), 'https://example.com');
    await tester.pump();

    expect(link, 'https://example.com');
  });
}