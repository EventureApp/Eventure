// test/backend_tests.dart
import 'package:eventure/statics/event_types.dart';
import 'package:eventure/statics/event_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:eventure/models/user.dart';
import 'package:eventure/models/event.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/providers/event_provider.dart';
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
      when(mockUserProvider.addUser(any)).thenAnswer((_) async => true);

      // Act
      var addUser = await mockUserProvider.addUser(mockUser);
      var result = await mockUserProvider.getUser('1');

      // Assert
      expect(result, isTrue);
      verify(mockUserProvider.addUser(mockUser)).called(1);
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
      when(mockEventProvider.addEvent(any)).thenAnswer((_) async => true);

      // Act
      var addEvent = await mockEventProvider.addEvent(mockEvent);
      var result = mockEventProvider.getEventFromId('1');

      // Assert
      expect(result, isTrue);
      verify(mockEventProvider.addEvent(mockEvent)).called(1);
    });
  });
}
