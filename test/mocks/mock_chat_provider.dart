import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:eventure/providers/chat_provider.dart';
import 'package:eventure/models/chat_message.dart';

class MockChatProvider extends Mock implements ChatProvider {
  @override
  void startListeningToChatMessages(String eventId) {
    super.noSuchMethod(
      Invocation.method(
        #startListeningToChatMessages,
        [eventId],
      ),
      returnValueForMissingStub: null,
    );
  }

  @override
  Future<void> addMessage(String message, String userId, String eventId) async {
    return super.noSuchMethod(
      Invocation.method(
        #addMessage,
        [message, userId, eventId],
      ),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }

  @override
  List<ChatMessage> get chatMessages => (super.noSuchMethod(
    Invocation.getter(#chatMessages),
    returnValue: <ChatMessage>[],
  ) as List<ChatMessage>);

  @override
  void dispose() {
    super.noSuchMethod(
      Invocation.method(
        #dispose,
        [],
      ),
      returnValueForMissingStub: null,
    );
  }
}
