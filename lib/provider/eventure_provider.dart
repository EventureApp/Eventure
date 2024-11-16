import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventure/models/event_model.dart';

class EventureProvider with ChangeNotifier {
  String _username = "undefined"; //Attribut nur zum Testen da, wird wahrscheinlich verändert
  set username(value){
    _username=value;
    notifyListeners();
  }
  String get username => _username;

  Map<int,EventModel> events = {1:EventModel(1,"Event 1 Eislaufen, Platzhalter für Event-Klasse"),2:EventModel(2,"Event 2 Bouldern, Platzhalter für Event-Klasse")};
  //Datenstruktur von Events wird sehr wahrscheinlich geändert, abhängig vom Backend
  List<EventModel> get eventsAsList => events.entries.map((entry) => entry.value).toList();
  //vielleicht performance-intensiv, wir müssen später schauen wie wir das machen, auch mit dem Sortieren von Events
  EventModel? getEventWithUUID (uuid)=>events[uuid];
  int _selectedEvent = 0;
  int get selectedEvent => _selectedEvent;
  set selectedEvent(value){
    _selectedEvent=value;
    notifyListeners();
  }

}