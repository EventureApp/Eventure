import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/models/event.dart';
import 'package:latlong2/latlong.dart';

import '../lat_lng.dart';
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

  Future<List<Event>> getAllInRange(LatLng center, double rangeInKm) async {
    LatLngBounds bounds = LatLngBounds.fromCenterAndRadius(center, rangeInKm);

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('location.latitude', isGreaterThanOrEqualTo: bounds.south)
        .where('location.latitude', isLessThanOrEqualTo: bounds.north)
        .where('location.longitude', isGreaterThanOrEqualTo: bounds.west)
        .where('location.longitude', isLessThanOrEqualTo: bounds.east)
        .get();

    final List<Event> events = snapshot.docs.map((doc) {
      return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    return events;
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
