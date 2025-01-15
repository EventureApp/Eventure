// test/chat_provider_tests.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks/mock_chat_provider.dart';
import 'package:eventure/services/db/chat_service.dart';

class MockChatService extends Mock implements ChatService {}

void main() {
  group('ChatProvider Tests', () {
    late MockChatProvider mockChatProvider;

    setUp(() {
      mockChatProvider = MockChatProvider();
    });

    test('Should call startListeningToChatMessages', () {
      // Act
      mockChatProvider.startListeningToChatMessages('testEventId');

      // Assert
      verify(mockChatProvider.startListeningToChatMessages('testEventId')).called(1);
    });

    test('Should add a message', () async {
      // Arrange
      when(mockChatProvider.addMessage('Hello', 'user123', 'event456'))
          .thenAnswer((_) async => Future.value());

      // Act
      await mockChatProvider.addMessage('Hello', 'user123', 'event456');

      // Assert
      verify(mockChatProvider.addMessage('Hello', 'user123', 'event456')).called(1);
    });
  });
}

