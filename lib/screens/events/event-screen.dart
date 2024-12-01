import 'package:eventure/models/event.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

import '../../statics/event_types.dart';
import '../../statics/event_visibility.dart';
import '../../widgets/inputs/custom-event-select.dart';
import '../../widgets/inputs/custom-location-select.dart';
import '../../widgets/inputs/custom_input_line.dart';
import '../../widgets/inputs/custom_date_time_picker.dart';
import '../../widgets/inputs/custom_discription_input.dart';
import '../../widgets/inputs/custom-link-select.dart';
import '../../widgets/inputs/custom-multi-select.dart';
import '../../widgets/inputs/custom-number-select.dart';
import '../../widgets/inputs/custom-single-select.dart';

class EventScreen extends StatefulWidget {
  final Event? event;

  EventScreen({this.event});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isEditing = false; // Standardmäßig Anzeigen-Modus
  final _formKey = GlobalKey<FormState>();

  // Felder für die Formulardaten
  late String _title;
  late DateTime _startDate;
  late DateTime _endDate;
  late LatLng _location;
  late EventType _eventType;
  late String _link;
  late int _maxParticipants;
  late String _description;

  bool _isFormValid = false; // Status, ob alle Pflichtfelder ausgefüllt sind

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      // Wenn ein Event geladen wird, initialisiere die Felder mit den Event-Daten
      _title = widget.event!.name;
      _startDate = widget.event!.startDate;
      _endDate = widget.event!.endDate;
      _location = widget.event!.location;
      _eventType = widget.event!.eventType;
      _link = widget.event!.eventLink!; // Stelle sicher, dass link vorhanden ist
      _maxParticipants = widget.event!.maxParticipants!; // Max Teilnehmer aus dem Event
      _description = widget.event!.description!; // Beschreibung aus dem Event
    } else {
      // Wenn das Event neu ist, setze leere oder Default-Werte
      _title = '';
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(Duration(hours: 1));
      _location = LatLng(0.0, 0.0);
      _eventType = EventType.someThingElse;
      _link = '';
      _maxParticipants = 0;
      _description = '';
    }
    _validateForm(); // Initiale Validierung
  }

  // Funktion zum Umschalten des Bearbeitungsmodus
  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // Funktion zum Speichern des Events
  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // Logik zum Speichern des Events, wie das Erstellen oder Aktualisieren eines Events
      print("Event gespeichert oder geändert");
    }
  }

  // Validierung der Pflichtfelder
  void _validateForm() {
    setState(() {
      _isFormValid = _title.isNotEmpty &&
          _description.isNotEmpty &&
          _startDate != _endDate &&
          _maxParticipants > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // AppBar wird blau
        title: widget.event == null
            ? Text("Create Event")
            : Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                widget.event!.icon,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 10),
            Text(widget.event!.name),
          ],
        ),
        actions: [
          // Settings-Button oben rechts für den Bearbeitungsmodus
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputLine(
                  label: "Title",
                  required: true,
                  editable: _isEditing,
                  onChanged: (title) {
                    setState(() {
                      _title = title;
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                ),
                CustomDateAndTimePicker(
                  label: "Start",
                  required: true,
                  editable: _isEditing,
                  onDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                ),
                const SizedBox(height: 20),
                CustomDateAndTimePicker(
                  label: "End",
                  required: true,
                  editable: _isEditing,
                  onDateChanged: (date) {
                    setState(() {
                      _endDate = date;
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                ),
                const SizedBox(height: 20),
                LocationSelect(
                  label: "Location",
                  isEditable: _isEditing,
                  onChanged: (location) {
                    setState(() {
                      _location = location!;
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                ),
                const SizedBox(height: 20),
                EventSelect(
                  label: 'Event Type',
                  initValues: widget.event != null ? [widget.event!.eventType] : [],
                  events: EventTypesWithIcon,
                  isMultiSelect: false,
                  isEditable: _isEditing,
                  onChanged: (selectedEvents) {
                    setState(() {
                      _eventType = selectedEvents[0];
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                ),
                const SizedBox(height: 20),
                CustomLinkInput(
                  label: "Link",
                  onChanged: (link) {
                    setState(() {
                      _link = link!;
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                ),
                const SizedBox(height: 20),
                CustomNumberInput(
                  label: "Max Teilnehmer",
                  onChanged: (maxParticipants) {
                    setState(() {
                      _maxParticipants = maxParticipants!;
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                ),
                const SizedBox(height: 20),
                CustomDescriptionInput(
                  label: "Description",
                  editable: _isEditing,
                  onChanged: (description) {
                    setState(() {
                      _description = description;
                    });
                    _validateForm(); // Validierung nach jeder Änderung
                  },
                  required: true,
                ),
                const SizedBox(height: 20),
                // Bestätigungsbutton, der das Event speichert
                ElevatedButton(
                  onPressed: _isFormValid ? _saveEvent : null,
                  child: Text("Save Event"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
