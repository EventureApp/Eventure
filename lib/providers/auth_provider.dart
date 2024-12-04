import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  Future<void> initializeAuth() async {
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await _firebaseAuth.currentUser?.reload();
    notifyListeners();
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
