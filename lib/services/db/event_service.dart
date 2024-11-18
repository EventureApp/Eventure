import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/models/event.dart';

import 'models/db_service.dart';

class EventService implements DatabaseService<Event> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> create(Event event) async {
    try {
      await _firestore.collection('events').add(event.toMap());
    } catch (e) {
      print("Error adding event: $e");
      throw e;
    }
  }

  @override
  Future<List<Event>> getAll() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error getting events: $e");
      rethrow;
    }
  }

  @override
  Future<void> update(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      print("Error updating event: $e");
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore.collection('events').doc(id).delete();
    } catch (e) {
      print("Error deleting event: $e");
      rethrow;
    }
  }
}
