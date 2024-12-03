import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/models/user.dart';

import 'models/db_service.dart';

class UserService implements DatabaseService<AppUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> create(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> delete(String id) async{
    await _firestore.collection('users').doc(id).delete();
  }

  @override
  Future<List<AppUser>> getAll() async{
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
    return AppUser.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<void> update(AppUser user) async{
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }
  /*
  This is implemented so we don't have to call the entire data base for the friends Operation
  */
  Future<AppUser> getSingleUser(String? id) async{
    DocumentSnapshot document = await _firestore.collection('users').doc(id).get();
    Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
    AppUser user = AppUser.fromMap(userData, id!);
    return user;
  }

  // If there are no Friends an empty List is returned!!!
  Future<List<AppUser>> getFriends(AppUser user) async{
    if (user.friends == null){
      return Future.value([]);
    }
    List<AppUser> friends = [];
    for (String friend in user.friends!) {
      AppUser user = await getSingleUser(friend);
      friends.add(user);
    }
    return friends;
  }
}