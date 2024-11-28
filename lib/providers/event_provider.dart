import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/event.dart';
import '../services/db/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];

  List<Event> get events => _events;

  List<Event> get filteredEvents => _filteredEvents;

  EventProvider() {
    fetchEvents();
    _filteredEvents = _events;
  }

  List<Marker> getLocations() {
    List<Marker> markers = [];
    for (var event in _events) {
      markers.add(Marker(
        point: event.location,
        child: const Icon(
          Icons.location_pin,
          color: Colors.red,
        ),
      ));
    }
    return markers;
  }

  Future<void> fetchEvents() async {
    _events = await _eventService.getAllInRange(
        const LatLng(49.4699765, 8.4819024), 1);
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    await _eventService.create(event);
    _events.add(event);
    notifyListeners();
  }

  @override
  String toString() {
    String events = "";
    for (Event event in _events) {
      events += event.toString();
    }
    return events;
  }
}
