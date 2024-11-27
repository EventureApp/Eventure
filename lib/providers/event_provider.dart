import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/db/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];

  List<Event> get events => _events;

  EventProvider() {
    fetchEvents();
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

  @override
  String toString() {
    String events = "";
    for (Event event in _events) {
      events += event.toString();
    }
    return events;
  }
}
