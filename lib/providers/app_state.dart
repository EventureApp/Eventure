import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../models/chat_message.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  bool _emailVerified = false;

  bool get emailVerified => _emailVerified;

  StreamSubscription<QuerySnapshot>? _chatSubscription;
  List<ChatMessage> _chatMessages = [];

  List<ChatMessage> get chatMessages => _chatMessages;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _emailVerified = user.emailVerified;
        _chatSubscription = FirebaseFirestore.instance
            .collection('chat')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _chatMessages = [];
          for (final document in snapshot.docs) {
            _chatMessages.add(
              ChatMessage(
                name: document.data()['name'] as String,
                message: document.data()['text'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _emailVerified = false;
        _chatMessages = [];
        _chatSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> refreshLoggedInUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return;
    }

    await currentUser.reload();
  }

  Future<DocumentReference> addMessageToChat(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('chat').add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
