import 'package:flutter/material.dart';

import '../models/event.dart';
import '../models/event_filter.dart';
import '../services/db/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];

  EventFilter _filter = EventFilter();

  List<Event> get events => _events;

  List<Event> get filteredEvents => _filteredEvents;

  EventFilter? get filter => _filter;

  EventProvider() {
    _fetchAllEvents();
  }

  Future<void> _fetchAllEvents() async {
    _events = await _eventService.getAll();
    _filteredEvents = List.from(_events);
    notifyListeners();
  }

  Event getEventFromId(String id) {
    return events.firstWhere((event) => event.id == id);
  }

  Future<void> _fetchEventsByLocation() async {
    _events =
        await _eventService.getAllInRange(_filter.location!, _filter.range!);
    _filteredEvents = List.from(_events);
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    await _eventService.create(event);
    _events.add(event);
    resetFilter();
    _applyFilter();
    _fetchEventsByLocation();
    notifyListeners();
  }

  void setSearchString(String searchString) {
    _filter.searchInput = searchString;
    _applyFilter();
  }

  void setFilter(EventFilter filter) {
    if (filter.location == null || filter.range == 0.0) {
      _fetchAllEvents();
    } else if (filter.location == null && filter.range != null) {
      return;
    } else if (filter.location != _filter.location || filter.range != _filter.range) {
      _filter = filter;
      _fetchEventsByLocation();
    }
    _filter = filter;
    _applyFilter();
  }

  void resetFilter() {
    setFilter(EventFilter(
        range: null,
        location: null,
        searchInput: null,
        startDate: null,
        endDate: null));
  }

  void _applyFilter() {
    _filteredEvents = events.where((event) {
      final matchesSearch = _filter.searchInput == null ||
          (event.name
              .toLowerCase()
              .contains(_filter.searchInput!.toLowerCase())) ||
          (event.address
              .toLowerCase()
              .contains(_filter.searchInput!.toLowerCase())) ||
          (event.description
                  ?.toLowerCase()
                  .contains(_filter.searchInput!.toLowerCase()) ??
              false);

      final matchesDateRange = (_filter.startDate == null ||
              event.endDate.isAfter(_filter.startDate!) ||
              event.endDate.isAtSameMomentAs(_filter.startDate!)) &&
          (_filter.endDate == null ||
              event.startDate.isBefore(_filter.endDate!) ||
              event.startDate.isAtSameMomentAs(_filter.endDate!));

      final matchesEventType = _filter.eventType == null ||
          _filter.eventType!.isEmpty ||
          _filter.eventType!.contains(event.eventType);
      return matchesSearch && matchesDateRange && matchesEventType;
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
