import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/models/event.dart';
import 'package:eventure/statics/event_visibility.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

import '../../statics/event_types.dart';
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
      final data = doc.data();

      final eventType = EventType.values.firstWhere(
        (e) => e.toString() == 'EventType.' + data['eventType'],
        orElse: () => EventType.someThingElse,
      );
      final EventVisability visabilityEvent = EventVisability.values.firstWhere(
        (e) => e.toString() == 'EventVisability.' + data['visability'],
        orElse: () => EventVisability.public,
      );

      final icon = IconData(
        data['icon'] as int,
        fontFamily: 'CustomIcons',
      );

      return Event(
        id: doc.id,
        name: data['name'] as String,
        description: data['description'] as String?,
        startDate: DateTime.parse(data['startDate'] as String),
        endDate: DateTime.parse(data['endDate'] as String),
        adress: data['adress'] as String,
        location: LatLng(
          data['location']['latitude'] as double,
          data['location']['longitude'] as double,
        ),
        icon: icon,
        eventType: eventType,
        eventLink: data['eventLink'] as String?,
        maxParticipants: data['participants'] as int?,
        organizer: data['organizer'] as String,
        visability: visabilityEvent
      );
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
