import 'package:eventure/services/db/models/entity.dart';
import 'package:latlong2/latlong.dart';

// TODO: adapt fields to final UI

class Event implements Entity {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final LatLng location;
  final String organizer;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      location: LatLng(
        map['location']['latitude'] as double,
        map['location']['longitude'] as double,
      ),
      organizer: map['organizer'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'organizer': organizer,
    };
  }
}
