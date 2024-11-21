import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String label;
  final List<String> initValues; // Initial ausgewählte Werte
  final Map<String, dynamic> data; // Die verfügbaren Optionen
  final Function(List<String>) onChanged; // Callback für Änderungen

  MultiSelectDropdown({
    required this.label,
    required this.initValues,
    required this.data,
    required this.onChanged,
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initValues); // Kopiere die initialen Werte
  }

  // Funktion zum Umschalten der Auswahl (ab-/anwählen)
  void _toggleSelection(String value) {
    setState(() {
      if (selectedValues.contains(value)) {
        selectedValues.remove(value); // Wenn der Wert bereits ausgewählt wurde, entfernen
      } else {
        selectedValues.add(value); // Wenn der Wert nicht ausgewählt wurde, hinzufügen
      }
    });
    widget.onChanged(selectedValues); // Rückgabe der neuen Liste der ausgewählten Werte
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            // Anzeigen eines modalen Dialogs mit den Auswahlmöglichkeiten
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Select Options'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.data.keys.map((option) {
                        return CheckboxListTile(
                          title: Text(option),
                          value: selectedValues.contains(option),
                          onChanged: (bool? value) {
                            _toggleSelection(option);
                            Navigator.of(context).pop();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: selectedValues.isEmpty
                  ? 'Please select options'
                  : selectedValues.join(', '), // Anzeige der ausgewählten Werte
              border: OutlineInputBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_drop_down),
                  SizedBox(width: 8),
                  Text(
                    selectedValues.isEmpty
                        ? 'Select options'
                        : selectedValues.join(', '), // Anzeige der ausgewählten Optionen
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
