import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventure/widgets/event_card.dart';
import 'package:eventure/widgets/map.dart';
import 'package:eventure/widgets/location_select_pop_over.dart';

void main() {
  group('EventCard Widget Tests', () {
    testWidgets('renders event details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EventCard(
            name: 'Test Event',
            startDate: DateTime(2025, 1, 1, 15, 0),
            address: '123 Street',
            icon: Icons.event,
            organizer: 'Organizer Name',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Test Event'), findsOneWidget);
      expect(find.text('1 Jan 2025, 15:00'), findsOneWidget);
      expect(find.text('Organizer Name'), findsOneWidget);
      expect(find.byIcon(Icons.event), findsOneWidget);
    });

    testWidgets(
        'triggers onTap callback when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: EventCard(
            name: 'Test Event',
            startDate: DateTime.now(),
            address: '123 Street',
            icon: Icons.event,
            organizer: 'Organizer',
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });
  });

  group('MapWidget Tests', () {
    testWidgets('LocationSelectPopover updates location on map tap', (
        WidgetTester tester) async {
      // Arrange
      LatLng? selectedLocation;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelectPopover(
              onChanged: (location) {
                selectedLocation = location;
              },
            ),
          ),
        ),
      );

      // Act
      // Simulieren Sie einen Klick auf die Karte
      await tester.tapAt(tester.getCenter(find.byType(MapWidget)));
      await tester.pump();

      // Assert
      // Überprüfen Sie, ob die ausgewählte Position aktualisiert wurde
      expect(selectedLocation, isNotNull);
      expect(selectedLocation!.latitude, isNot(0.0));
      expect(selectedLocation!.longitude, isNot(0.0));
    });
  });

  group('LocationSelect Widget Tests', () {
    testWidgets(
        'LocationSelectPopover can be opened and closed without selecting a location', (
        WidgetTester tester) async {
      // Arrange
      LatLng? selectedLocation;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LocationSelectPopover(
                          onChanged: (location) {
                            selectedLocation = location;
                          },
                        );
                      },
                    );
                  },
                  child: Text('Show Popover'),
                );
              },
            ),
          ),
        ),
      );

      // Act
      // Öffnen Sie den Dialog
      await tester.tap(find.text('Show Popover'));
      await tester.pumpAndSettle();

      // Schließen Sie den Dialog, ohne eine Location auszuwählen
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert
      // Überprüfen Sie, ob keine Location ausgewählt wurde
      expect(selectedLocation, isNull);
    });

    testWidgets('LocationSelectPopover updates location on map tap', (
        WidgetTester tester) async {
      // Arrange
      LatLng? selectedLocation;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LocationSelectPopover(
                          onChanged: (location) {
                            selectedLocation = location;
                          },
                        );
                      },
                    );
                  },
                  child: Text('Show Popover'),
                );
              },
            ),
          ),
        ),
      );

      // Act
      // Öffnen Sie den Dialog
      await tester.tap(find.text('Show Popover'));
      await tester.pumpAndSettle();

      // Simulieren Sie einen Klick auf die Karte
      await tester.tapAt(tester.getCenter(find.byType(MapWidget)));
      await tester.pump();

      // Schließen Sie den Dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert
      // Überprüfen Sie, ob die ausgewählte Position aktualisiert ;wurde
      expect(selectedLocation, isNotNull);
      expect(selectedLocation!.latitude, isNot(0.0));
      expect(selectedLocation!.longitude, isNot(0.0));
    });
  });
}