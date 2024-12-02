import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/db/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];

  List<User> get users => _users;

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async{
    _users = await _userService.getAll();
    notifyListeners();
  }

  Future<void> addUser(User user) async{
    await _userService.create(user);
    _users.add(user);
    notifyListeners();
  }

  @override
  String toString() {
    String users = "";
    for (User user in _users) {
      users += user.toString();
    }
    return users;
  }

}