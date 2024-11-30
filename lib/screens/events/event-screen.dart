import 'package:eventure/models/event.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

import '../../statics/event_types.dart';
import '../../widgets/inputs/custom-event-select.dart';
import '../../widgets/inputs/custom-location-select.dart';  // Dein LocationSelect importieren
import '../../widgets/inputs/custom_input_line.dart';
import '../../widgets/inputs/custom_date_time_picker.dart';
import '../../widgets/inputs/custom_discription_input.dart';
import '../../widgets/inputs/custom-link-select.dart';
import '../../widgets/inputs/custom-multi-select.dart';
import '../../widgets/inputs/custom-number-select.dart';
import '../../widgets/inputs/custom-single-select.dart'; // Angenommen, CustomSelect ist der Name der Dropdown-Komponente

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  Event? event;
  DateTime? selectedDateTime;
  String? selectedSingleKey;
  List<String> selectedMultiKeys = [];

  // Beispielwerte für Multi- und Single-Select
  Map<String, dynamic> selectData = {
    'Option 1': 'Wert 1',
    'Option 2': 'Wert 2',
    'Option 3': 'Wert 3',
    'Option 4': 'Wert 4',
  };

  List<String> selectedEvents = ['Event 1', 'Event 3']; // Initialwerte für EventSelect
  LatLng? _location = null;
  int? _age;
  String? _website;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now(); // Initialisiere mit dem aktuellen Datum
    selectedSingleKey = 'Option 2'; // Initialwert für SingleSelect
    selectedMultiKeys = ['Option 1', 'Option 3']; // Initialwerte für MultiSelect
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputLine(label: "Tile", required: true, editable: true, onChanged: (title) {
                print(title);
              }),
              CustomDateAndTimePicker(label: "Start", required: true, editable: true, onDateChanged: (date) {
                print(date);
              }),
              const SizedBox(height: 20),
              CustomDateAndTimePicker(label: "End", required: true, editable: true, onDateChanged: (date) {
                print(date);
              }),
              const SizedBox(height: 20),
              LocationSelect(label: "Location", onChanged: (location) => {
                print(location)
              }),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              EventSelect(
                label: 'Event Type', // Label für das Dropdown
                initValues: [], // Liste der initial ausgewählten Events (nur eines)
                events: EventTypesWithIcon, // Die Map mit Events und den Flutter-Icons
                isMultiSelect: false, // SingleSelect aktiv
                onChanged: (selectedEvents) {
                  setState(() {
                    print(selectedEvents);
                  });
                  print("Selected Event: $selectedEvents");
                },
              ),
              const SizedBox(height: 20),
              CustomLinkInput(label: "Link", onChanged: (link) {
                print(link);
              }),
              const SizedBox(height: 20),
              CustomNumberInput(label: "Max Teilnehmer", onChanged: (age) {
                print(age);
              }),
              const SizedBox(height: 20),
              CustomDescriptionInput(label: "Description", onChanged: (description) {
                print(description);
              }, required: true, editable: true,),
            ],
          ),
        ),
      ),
    );
  }
}

