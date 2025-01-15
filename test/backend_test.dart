// test/backend_tests.dart
import 'package:eventure/statics/event_types.dart';
import 'package:eventure/statics/event_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:eventure/models/user.dart';
import 'package:eventure/models/event.dart';
import './mocks/mock_database.mocks.dart';

void main() {
  group('User Provider Tests', () {
    late MockUserProvider mockUserProvider;
    late AppUser mockUser;

    setUp(() {
      mockUserProvider = MockUserProvider();
      mockUser = AppUser(id: '1', username: 'Test User');
    });

    test('Should fetch user by id', () async {
      // Arrange
      when(mockUserProvider.getUser('1')).thenAnswer((_) async => mockUser);

      // Act
      var user = await mockUserProvider.getUser('1');

      // Assert
      expect(user, isNotNull);
      expect(user.id, '1');
      expect(user.username, 'Test User');
    });

    test('Should add a new user', () async {
      // Arrange
      when(mockUserProvider.addUser(any))
          .thenAnswer((_) async => Future.value()); // Void-Methode stubben
      when(mockUserProvider.getUser('1'))
          .thenAnswer((_) async => mockUser); // Stub für getUser

      // Act
      mockUserProvider.addUser(mockUser); // addUser aufrufen
      var user = await mockUserProvider.getUser('1'); // getUser aufrufen

      // Assert
      expect(user, isNotNull);
      expect(user.id, '1');
      expect(user.username, 'Test User');
      verify(mockUserProvider.addUser(mockUser))
          .called(1); // Sicherstellen, dass addUser aufgerufen wurde
    });
  });

  group('Event Provider Tests', () {
    late MockEventProvider mockEventProvider;
    late Event mockEvent;

    setUp(() {
      mockEventProvider = MockEventProvider();
      mockEvent = Event(
          id: '1',
          name: 'Test Event',
          organizer: '1',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(hours: 1)),
          address: "Test Location",
          icon: Icons.event,
          eventType: EventType.other,
          visibility: EventVisability.friendsOnly,
          description: 'Test Description',
          location: const LatLng(0, 0));
    });

    test('Should fetch event by id', () async {
      // Arrange
      when(mockEventProvider.getEventFromId('1')).thenAnswer((_) => mockEvent);

      // Act
      var event = mockEventProvider.getEventFromId('1');

      // Assert
      expect(event, isNotNull);
      expect(event.id, '1');
      expect(event.name, 'Test Event');
      expect(event.address, 'Test Location');
    });

    test('Should add a new event', () async {
      // Arrange
      when(mockEventProvider.addEvent(any))
          .thenAnswer((_) async => Future.value());
      when(mockEventProvider.getEventFromId('1'))
          .thenReturn(mockEvent); // Stub für getEventFromId

      // Act
      mockEventProvider.addEvent(mockEvent); // addEvent aufrufen
      var event =
          mockEventProvider.getEventFromId('1'); // getEventFromId aufrufen

      // Assert
      expect(event, isNotNull);
      expect(event.id, '1');
      expect(event.name, 'Test Event');
      verify(mockEventProvider.addEvent(mockEvent))
          .called(1); // Sicherstellen, dass addEvent aufgerufen wurde
    });
  });
}
