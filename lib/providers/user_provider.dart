import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/db/user_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  List<AppUser> _users = [];
  List<AppUser> _friends = [];
  AppUser _user = AppUser(username: '');
  String _queryStartsWith = "";
  List<AppUser> _usersStartingWith = [];

  set queryStartsWith(String string) {
    _queryStartsWith = string;
  }

  AppUser get user => _user;

  List<AppUser> get friends => _friends;

  List<AppUser> get users => _users;
  List<AppUser> get usersStartingWith => _usersStartingWith;

  UserProvider() {}

  void initializeUser() {
    if (_firebaseAuth.currentUser != null) {
      fetchUsers();
      getCurrentUser(_firebaseAuth.currentUser?.uid);
      fetchFriends();
    }
  }

  Future<void> getCurrentUser(String? id) async {
    _user = await _userService.getSingleUser(id);
    notifyListeners();
  }

  Future<AppUser> getUser(String id) async {
    return await _userService.getSingleUser(id);
  }

  String getUserName(String id) {
    for (AppUser user in _users) {
      if (id == user.id) {
        getCurrentUser(id);
        return user.username;
      }
    }
    return "";
  }

  Future<void> updateUser(AppUser user) async {
    await _userService.update(user);
    _user = user;
    notifyListeners();
  }

  Future<void> fetchFriends() async {
    _friends = await _userService.getFriends(_user);
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _users = await _userService.getAll();
    notifyListeners();
  }

  Future<void> fetchUsersStartingWith() async {
    _usersStartingWith = await _userService.getStartingWith(_queryStartsWith);
    notifyListeners();
  }

  Future<void> addUser(AppUser user) async {
    await _userService.create(user);
    _users.add(user);
    notifyListeners();
  }

  @override
  String toString() {
    String users = "";
    for (AppUser user in _users) {
      users += user.toString();
    }
    return users;
  }
}
