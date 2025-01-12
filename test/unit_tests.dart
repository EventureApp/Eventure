import 'package:flutter_test/flutter_test.dart';
import 'package:eventure/models/event.dart';

void main() {
  group('Event Model Tests', () {
    test('Event creation', () {
      final event = Event(
        name: 'Test Event',
        startDate: DateTime(2025, 1, 1, 15, 0),
        endDate: DateTime(2025, 1, 1, 18, 0),
        location: LatLng(0.0, 0.0),
        address: '123 Street',
        eventType: EventType.other,
        icon: Icons.event,
        visibility: EventVisability.public,
        eventLink: 'http://example.com',
        maxParticipants: 100,
        description: 'Test Description',
        organizer: 'Organizer Name',
      );

      expect(event.name, 'Test Event');
      expect(event.startDate, DateTime(2025, 1, 1, 15, 0));
      expect(event.endDate, DateTime(2025, 1, 1, 18, 0));
      expect(event.location, LatLng(0.0, 0.0));
      expect(event.address, '123 Street');
      expect(event.eventType, EventType.other);
      expect(event.icon, Icons.event);
      expect(event.visibility, EventVisability.public);
      expect(event.eventLink, 'http://example.com');
      expect(event.maxParticipants, 100);
      expect(event.description, 'Test Description');
      expect(event.organizer, 'Organizer Name');
    });
  });
}
