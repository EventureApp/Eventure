import 'package:eventure/services/db/models/entity.dart';
import 'package:eventure/statics/event_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import '../statics/event_visibility.dart';

class Event implements Entity {
  final String? id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String adress;
  final LatLng location;
  final IconData icon;
  final EventType eventType;
  final EventVisability visability;
  final String? eventLink;
  final int? maxParticipants;
  final String? organizer;

  Event( {
    this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.adress,
    required this.location,
    required this.icon,
    required this.eventType,
    required this.visability,
    this.eventLink,
    this.maxParticipants,
    required this.organizer,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    EventType eventType = EventType.values.firstWhere(
      (e) => e.toString() == 'EventType.' + map['eventType'],
      orElse: () => EventType.someThingElse,
    );

    EventVisability visabilityEvent = EventVisability.values.firstWhere(
      (e) => e.toString() == 'EventVisability.' + map['visability'],
      orElse: () => EventVisability.public,
    );

    IconData icon = IconData(
      map['icon'] as int,
      fontFamily: 'CustomIcons',
    );

    return Event(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      adress: map['adress'] as String,
      location: LatLng(
        map['location']['latitude'] as double,
        map['location']['longitude'] as double,
      ),
      icon: icon,
      eventType: eventType,
      eventLink: map['eventLink'] as String?,
      maxParticipants: map['maxParticipants'] as int?,
      organizer: map['organizer'] as String,
      visability: visabilityEvent,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'adress': adress,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'icon': icon.codePoint,
      'eventType': eventType.toString().split('.').last,
      'eventLink': eventLink,
      'participants': maxParticipants,
      'organizer': organizer,
      'visability': visability.toString().split('.').last,
    };
  }
}
