import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/event.dart';
import '../models/event_filter.dart';
import '../services/db/event_service.dart';

class EventProvider with ChangeNotifier {
  static const double DEFAULT_RANGE = 10.0;

  final EventService _eventService = EventService();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];

  EventFilter _filter = EventFilter(range: DEFAULT_RANGE);

  List<Event> get events => _events;

  List<Event> get filteredEvents => _filteredEvents;

  EventProvider() {
    fetchEvents();
  }

  List<Marker> getLocations() {
    List<Marker> markers = [];
    for (var event in _filteredEvents) {
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
        const LatLng(49.4699765, 8.4819024), _filter.range);
    _filteredEvents = List.from(_events);
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    await _eventService.create(event);
    _events.add(event);
    notifyListeners();
  }

  void setSearchString(String searchString) {
    _filter.searchInput = searchString;
    _applyFilter();
  }

  void _applyFilter() {
    _filteredEvents = events.where((event) {
      final matchesSearch = _filter.searchInput == null ||
          event.name.toLowerCase().contains(_filter.searchInput!.toLowerCase());

      final matchesDateRange = (_filter.startDate == null ||
              event.endDate.isAfter(_filter.startDate!) ||
              event.endDate.isAtSameMomentAs(_filter.startDate!)) &&
          (_filter.endDate == null ||
              event.startDate.isBefore(_filter.endDate!) ||
              event.startDate.isAtSameMomentAs(_filter.endDate!));

      return matchesSearch && matchesDateRange;
    }).toList();

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
