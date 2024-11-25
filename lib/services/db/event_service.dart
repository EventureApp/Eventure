import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/models/event.dart';

import 'models/db_service.dart';

class EventService implements DatabaseService<Event> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> create(Event event) async {
    await _firestore.collection('events').add(event.toMap());
  }

  @override
  Future<List<Event>> getAll() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) {
      return Event.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<void> update(Event event) async {
    await _firestore.collection('events').doc(event.id).update(event.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _firestore.collection('events').doc(id).delete();
  }
}
