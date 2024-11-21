import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/event.dart';
import '../services/db/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];

  List<Event> get events => _events;

  EventProvider() {
    fetchEvents();
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
    _events = await _eventService.getAll();
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    await _eventService.create(event);
    _events.add(event);
    notifyListeners();
  }
}
