import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

import '../models/event.dart';
import '../services/db/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<LatLng> _eventLocations = [];

  List<LatLng> get eventLocations => _eventLocations;

  Future<void> fetchEventLocations() async {
    try {
      final events = await _eventService.getAll();
      _eventLocations = events.map((event) => event.location).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching event locations: $e");
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      await _eventService.create(event);
      await fetchEventLocations();
      notifyListeners();
    } catch (e) {
      print("Error adding event: $e");
    }
  }
}
