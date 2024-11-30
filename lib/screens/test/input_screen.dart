import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

import 'package:eventure/widgets/inputs/custom-event-select.dart';
import 'package:eventure/widgets/inputs/custom-location-select.dart';  // Dein LocationSelect importieren
import 'package:eventure/widgets/inputs/custom_input_line.dart';
import 'package:eventure/widgets/inputs/custom_date_time_picker.dart';
import 'package:eventure/widgets/inputs/custom_discription_input.dart';
import '../../widgets/inputs/custom-link-select.dart';
import '../../widgets/inputs/custom-multi-select.dart';
import '../../widgets/inputs/custom-number-select.dart';
import '../../widgets/inputs/custom-single-select.dart'; // Angenommen, CustomSelect ist der Name der Dropdown-Komponente

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
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

  Map<String, IconData> eventIcons = {
    'Event 1': Icons.event,          // Event-Icon
    'Event 2': Icons.star,           // Stern-Icon
    'Event 3': Icons.access_alarm,   // Alarm-Icon
    'Event 4': Icons.accessibility,  // Zugänglichkeits-Icon
    'Event 5': Icons.favorite,       // Herz-Icon
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
              // Custom Date and Time Picker
              CustomDateAndTimePicker(
                label: 'Start Date and Time',
                initValue: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), // Beispielwert
                required: true,
                editable: true,
                onDateChanged: (dateTime) {
                  print("Ausgewähltes Datum und Uhrzeit: $dateTime");
                },
              ),

              // Zweiter Custom Date and Time Picker
              CustomDateAndTimePicker(
                label: 'End Date and Time',
                initValue: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), // Datum richtig formatieren
                required: false,
                editable: true,
                onDateChanged: (dateTime) {
                  print("Ausgewähltes Enddatum und Uhrzeit: $dateTime");
                },
              ),

              // Custom Input Line
              CustomInputLine(
                label: 'User Name',
                initValue: 'Max Mustermann',
                required: true,
                editable: true,
                onChanged: (input) {
                  print("Name geändert: $input");
                },
              ),

              // Custom Description Input
              CustomDescriptionInput(
                label: 'Description',
                initValue: 'Dies ist eine Beispielbeschreibung.',
                required: false,
                editable: true,
                onChanged: (input) {
                  print("Beschreibung geändert: $input");
                },
              ),

              // SingleSelect Dropdown
              SingleSelectDropdown(
                label: 'Select Option',
                initValue: selectedSingleKey,
                data: selectData,
                onChanged: (selectedKey) {
                  setState(() {
                    selectedSingleKey = selectedKey;
                  });
                  print("Ausgewählte Option: $selectedKey");
                },
              ),

              // MultiSelect Dropdown
              MultiSelectDropdown(
                label: 'Select Multiple Options',
                initValues: selectedMultiKeys,
                data: selectData,
                onChanged: (selectedKeys) {
                  setState(() {
                    selectedMultiKeys = selectedKeys;
                  });
                  print("Ausgewählte Optionen: $selectedKeys");
                },
              ),

              // Event Selects
              EventSelect(
                label: 'Select Multi Events',
                initValues: selectedEvents, // Liste der initial ausgewählten Events
                events: eventIcons, // Die Map mit Events und den Flutter-Icons
                isMultiSelect: true, // MultiSelect aktiv
                onChanged: (selectedEvents) {
                  setState(() {
                    this.selectedEvents = selectedEvents;
                  });
                  print("Selected Events: $selectedEvents");
                },
              ),
              EventSelect(
                label: 'Select Single Event',
                initValues: selectedEvents, // Liste der initial ausgewählten Events (nur eines)
                events: eventIcons, // Die Map mit Events und den Flutter-Icons
                isMultiSelect: false, // SingleSelect aktiv
                onChanged: (selectedEvents) {
                  setState(() {
                    this.selectedEvents = selectedEvents;
                  });
                  print("Selected Event: $selectedEvents");
                },
              ),

              const SizedBox(height: 20),

              // Location Select
              LocationSelect(
                label: "Wähle location: ", // Das Label für das Widget
                initValue: this._location, // Initialer Wert (Falls vorhanden)
                isEditable: false,
                onChanged: (location) {
                  setState(() {
                    _location = location;
                  });
                  print("Ausgewählte Location: $location"); // Callback zum Aktualisieren der Location
                }, // Callback zum Aktualisieren der Location
              ),
              ElevatedButton(
                onPressed: () {
                  // Beispielaktion: Weiterverarbeitung der Daten
                  print("Selected Date: ${selectedDateTime?.toString()}");
                  print("Selected Single Option: $selectedSingleKey");
                  print("Selected Multi Options: $selectedMultiKeys");
                },
                child: Text("Submit"),
              ),
              CustomNumberInput(
                label: 'Anzahl der Teilnehmer ',
                isMandatory: true, // Pflichtfeld
                hint: 'Enter your age',
                onChanged: (value) {
                  setState(() {
                    _age = value; // Alter setzen
                  });
                },
              ),

              CustomLinkInput(
                label: 'Website',
                isMandatory: false, // Optionales Feld
                hint: 'Enter your website URL',
                onChanged: (value) {
                  setState(() {
                    _website = value; // Website-Link setzen
                  });
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

