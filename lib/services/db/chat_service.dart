import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chat_message.dart';
import 'models/db_service.dart';

class ChatService implements DatabaseService<ChatMessage> {
  static final ChatService _instance = ChatService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  @override
  Future<List<ChatMessage>> getAll() async {
    final snapshot = await _firestore
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return ChatMessage.fromMap(doc.data());
    }).toList();
  }

  Stream<List<ChatMessage>> getAllByStream(String eventId) {
    return _firestore
        .collection('chat')
        .where('eventId', isEqualTo: eventId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessage(
          text: doc.data()['message'] ?? '',
          timestamp: doc.data()['timestamp'],
          userId: doc.data()['userId'],
          eventId: eventId,
        );
      }).toList();
    });
  }

  @override
  Future<void> create(ChatMessage item) {
    return _firestore.collection('chat').add(item.toMap());
  }

  @override
  Future<void> update(ChatMessage item) {
    if (item.id != null) {
      return _firestore.collection('chat').doc(item.id).update(item.toMap());
    } else {
      throw Exception('Cannot update a ChatMessage without an id');
    }
  }

  @override
  Future<void> delete(String id) {
    return _firestore.collection('chat').doc(id).delete();
  }

  Future<void> addMessage(String message, String userId, String eventId) {
    final newMessage = ChatMessage(
      text: message,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      eventId: eventId,
    );
    return create(newMessage);
  }
}
