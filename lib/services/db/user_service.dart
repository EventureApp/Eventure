import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/models/user.dart';

import 'models/db_service.dart';

class UserService implements DatabaseService<User> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> create(User user) async {
    await _firestore.collection('users').add(user.toMap());
  }

  @override
  Future<void> delete(String id) async{
    await _firestore.collection('users').doc(id).delete();
  }

  @override
  Future<List<User>> getAll() async{
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
    return User.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<void> update(User user) async{
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }
}