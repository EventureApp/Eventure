import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/inputs/custom_date_time_picker.dart';
import '../../widgets/inputs/custom-single-select.dart';
import '../../widgets/inputs/custom-number-select.dart';
import '../../widgets/inputs/custom-location-select.dart';
import '../../widgets/inputs/custom-event-select.dart';
import '../../statics/event_visibility.dart';
import '../../statics/event_types.dart';

class EventFilterScreen extends StatefulWidget {
  @override
  _EventFilterScreenState createState() => _EventFilterScreenState();
}

class _EventFilterScreenState extends State<EventFilterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Felder für die Filterdaten
  late DateTime? _startDate;
  late DateTime? _endDate;
  late EventVisability _visibility;
  late EventType _eventType;
  late LatLng? _location;
  late int? _radius;

  @override
  void initState() {
    super.initState();

    // Initialisiere Filter mit Default-Werten
    _startDate = null;
    _endDate = null;
    _visibility = EventVisability.public;
    _eventType = EventType.someThingElse;
    _location = null;
    _radius = null;
  }

  void _applyFilters() {
    if (_formKey.currentState!.validate()) {
      // Gib die Filterwerte aus (hier könntest du die Daten weiterverarbeiten oder an den Provider senden)
      print("Start Date: $_startDate");
      print("End Date: $_endDate");
      print("Visibility: $_visibility");
      print("Event Type: $_eventType");
      print("Location: $_location");
      print("Radius: $_radius");

      // Feedback für den Nutzer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Filters applied!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Icon(Icons.filter_list, color: Colors.white),
            SizedBox(width: 8),
            Text("Filter Events"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Startdatum
                  CustomDateAndTimePicker(
                    label: "Start Date",
                    required: false,
                    editable: true,
                    onDateChanged: (date) {
                      setState(() {
                        _startDate = date;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Enddatum
                  CustomDateAndTimePicker(
                    label: "End Date",
                    required: false,
                    editable: true,
                    onDateChanged: (date) {
                      setState(() {
                        _endDate = date;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Sichtbarkeit (Dropdown)
                  SingleSelectDropdown(
                    label: 'Visibility',
                    initValue: _visibility.toString().split('.').last,
                    data: eventVisibilityData,
                    required: true,
                    editable: true,
                    onChanged: (value) {
                      setState(() {
                        _visibility = eventVisibilityData[value];
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Event-Typ (Einzelauswahl)
                  EventSelect(
                    label: 'Event Type',
                    isEditable: true,
                    initValues: [_eventType],
                    events: EventTypesWithIcon,
                    isMultiSelect: true,
                    onChanged: (selected) {
                      setState(() {
                        _eventType = selected[0];
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Standort
                  LocationSelect(
                    label: "Location",
                    isEditable: true,
                    onChanged: (location) {
                      setState(() {
                        _location = location;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Radius
                  CustomNumberInput(
                    label: "Radius (km)",
                    onChanged: (value) {
                      setState(() {
                        _radius = value;
                      });
                    },
                  ),
                  SizedBox(height: 32),

                  // Filter-Button
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text("Filter"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
