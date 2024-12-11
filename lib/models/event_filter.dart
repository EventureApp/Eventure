import 'package:eventure/statics/event_types.dart';
import 'package:latlong2/latlong.dart';

class EventFilter {
  String? searchInput;
  double range;
  LatLng location;
  DateTime? startDate;
  DateTime? endDate;
  List<EventType>? eventType;

  EventFilter({
    this.searchInput,
    required this.range,
    required this.location,
    this.startDate,
    this.endDate,
    this.eventType,
  });

  @override
  String toString() {
    return "$searchInput, $range, $location, $startDate, $endDate, $eventType";
  }
}
