import 'dart:async';

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/db/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ChatMessage> _chatMessages = [];
  StreamSubscription<List<ChatMessage>>? _chatMessagesSubscription;

  List<ChatMessage> get chatMessages => _chatMessages;

  void startListeningToChatMessages(String eventId) {
    _chatMessagesSubscription =
        _chatService.getAllByStream(eventId).listen((messages) {
      _chatMessages = messages;
      notifyListeners();
    }, onError: (error) {});
  }

  @override
  void dispose() {
    _chatMessagesSubscription?.cancel();
    super.dispose();
  }

  Future<void> addMessage(String message, String userId, String eventId) async {
    try {
      await _chatService.addMessage(message, userId, eventId);
    } catch (error) {
      print('Error adding message: $error');
    }
  }
}
