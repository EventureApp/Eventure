//test/event_model_test.dart
import 'package:eventure/statics/event_types.dart';
import 'package:eventure/statics/event_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:eventure/models/event.dart';

void main() {
  group('Event Model Tests', () {
    late Event event;

    setUp(() {
      event = Event(
        id: 'event1',
        name: 'Test Event',
        description: 'This is a test event',
        startDate: DateTime(2025, 1, 15, 10, 0),
        endDate: DateTime(2025, 1, 15, 12, 0),
        address: '123 Test Street',
        location: const LatLng(52.52, 13.405),
        icon: Icons.event,
        eventType: EventType.study,
        visibility: EventVisability.private,
        eventLink: 'https://example.com',
        maxParticipants: 100,
        organizer: '',
      );
    });

    test('Constructor should create a valid Event object', () {
      expect(event.id, 'event1');
      expect(event.name, 'Test Event');
      expect(event.description, 'This is a test event');
      expect(event.startDate, DateTime(2025, 1, 15, 10, 0));
      expect(event.endDate, DateTime(2025, 1, 15, 12, 0));
      expect(event.address, '123 Test Street');
      expect(event.location, LatLng(52.52, 13.405));
      expect(event.icon, Icons.event);
      expect(event.eventType, EventType.study);
      expect(event.visibility, EventVisability.private);
      expect(event.eventLink, 'https://example.com');
      expect(event.maxParticipants, 100);
      expect(event.organizer, '');
    });

    test('fromMap should create an Event object from a Map', () {
      final map = {
        'name': 'Test Event',
        'description': 'This is a test event',
        'startDate': '2025-01-15T10:00:00.000',
        'endDate': '2025-01-15T12:00:00.000',
        'address': '123 Test Street',
        'location': {
          'latitude': 52.52,
          'longitude': 13.405,
        },
        'icon': {'fontFamily': event.icon.fontFamily, 'codePoint': event.icon.codePoint},
        'eventType': EventType.study.index,
        'visibility': EventVisability.private.index,
        'eventLink': 'https://example.com',
        'participants': 100,
        'organizer': '',
      };

      final eventFromMap = Event.fromMap(map, 'event1');

      expect(eventFromMap.id, 'event1');
      expect(eventFromMap.name, 'Test Event');
      expect(eventFromMap.description, 'This is a test event');
      expect(eventFromMap.startDate, DateTime(2025, 1, 15, 10, 0));
      expect(eventFromMap.endDate, DateTime(2025, 1, 15, 12, 0));
      expect(eventFromMap.address, '123 Test Street');
      expect(eventFromMap.location, const LatLng(52.52, 13.405));
      expect(eventFromMap.icon, Icons.event);
      expect(eventFromMap.eventType, EventType.study);
      expect(eventFromMap.visibility, EventVisability.private);
      expect(eventFromMap.eventLink, 'https://example.com');
      expect(eventFromMap.maxParticipants, 100);
      expect(eventFromMap.organizer, '');
    });

    test('toString should return a readable string representation of Event', () {
      const expectedString = "id: event1 \n name: Test Event \n descr: This is a test event \n "
          "startDate: 2025-01-15 10:00:00.000 \n endDate: 2025-01-15 12:00:00.000 \n address: 123 Test Street \n "
          "location: LatLng(latitude:52.52, longitude:13.405) \n icon: IconData(U+0E23E) \n eventType: EventType.study \n "
          "eventLink: https://example.com \n maxParticipants: 100 \n "
          "organizer:  \n \n";


      expect(event.toString(), expectedString);
    });
  });
}
