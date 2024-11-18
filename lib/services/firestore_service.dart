import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  Stream<List<ChatMessage>> getChatMessages() {
    return _firestore
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessage(
          name: doc.data()['name'] ?? 'Unknown',
          message: doc.data()['text'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> addMessage(String message, String userName, String userId) {
    return _firestore.collection('chat').add({
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': userName,
      'userId': userId,
    });
  }
}
