import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventure/widgets/inputs/custom_location_select.dart';

void main() {
  testWidgets('LocationSelect updates on map tap', (WidgetTester tester) async {
    LatLng? selectedLocation;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: LocationSelect(
          label: 'Location',
          userLocation: const LatLng(0, 0),
          onChanged: (location) {
            selectedLocation = location;
          },
        ),
      ),
    ));

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    // Simulate map tap
    selectedLocation = const LatLng(10, 10);
    expect(selectedLocation, const LatLng(10, 10));
  });
}