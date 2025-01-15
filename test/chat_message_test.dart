// test/chat_message_tests.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:eventure/models/chat_message.dart';
import 'package:eventure/services/db/chat_service.dart';

class MockChatService extends Mock implements ChatService {}

void main() {
  group('ChatMessage Model Tests', () {
    test('Should convert ChatMessage to Map', () {
      // Arrange
      final chatMessage = ChatMessage(
        id: '1',
        text: 'Hello, World!',
        timestamp: 1633024800,
        userId: 'user1',
        eventId: 'event1',
      );

      // Act
      final map = chatMessage.toMap();

      // Assert
      expect(map['message'], 'Hello, World!');
      expect(map['timestamp'], 1633024800);
      expect(map['userId'], 'user1');
      expect(map['eventId'], 'event1');
    });

    test('Should create ChatMessage from Map', () {
      // Arrange
      final map = {
        'message': 'Hello, World!',
        'timestamp': 1633024800,
        'userId': 'user1',
        'eventId': 'event1',
      };

      // Act
      final chatMessage = ChatMessage.fromMap(map);

      // Assert
      expect(chatMessage.text, 'Hello, World!');
      expect(chatMessage.timestamp, 1633024800);
      expect(chatMessage.userId, 'user1');
      expect(chatMessage.eventId, 'event1');
    });
  });
}
