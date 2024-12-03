import 'package:eventure/providers/auth_provider.dart';
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
  final String address;
  final LatLng location;
  final IconData icon;
  final EventType eventType;
  final EventVisability visability;
  final String? eventLink;
  final int? maxParticipants;
  final String? organizer;

  Event({
    this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.location,
    required this.icon,
    required this.eventType,
    required this.visability,
    this.eventLink,
    this.maxParticipants,
    required this.organizer,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    IconData icon = IconData(
      map['icon'] as int,
      fontFamily: 'CustomIcons',
    );

    return Event(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String?,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      address: map['address'] as String,
      location: LatLng(
        map['location']['latitude'] as double,
        map['location']['longitude'] as double,
      ),
      icon: icon,
      eventType: EventType.values[map['eventType'] as int],
      eventLink: map['eventLink'] as String?,
      maxParticipants: map['participants'] as int?,
      organizer: map['organizer'] as String,
      visability: EventVisability.values[map['visibility'] as int],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'address': address,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'icon': icon.codePoint,
      'eventType': eventType.index,
      'eventLink': eventLink,
      'participants': maxParticipants,
      'organizer': AuthenticationProvider().currentUser?.uid,
      'visability': visability.index,
    };
  }

  @override
  String toString() {
    return "id: $id \n name: $name \n descr: $description \n "
        "startDate: $startDate \n endDate: $endDate \n address: $address \n "
        "location: $location \n icon: $icon \n eventType: $eventType \n "
        "eventLink: $eventLink \n maxParticipants: $maxParticipants \n "
        "organizer: $organizer \n \n";
  }
}
