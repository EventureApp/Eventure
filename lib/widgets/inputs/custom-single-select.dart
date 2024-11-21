import 'package:flutter/material.dart';

class SingleSelectDropdown extends StatefulWidget {
  final String label;
  final String? initValue; // Initialer Wert
  final Map<String, dynamic> data; // Die verfügbaren Optionen
  final Function(String?) onChanged; // Callback für Änderungen

  SingleSelectDropdown({
    required this.label,
    this.initValue,
    required this.data,
    required this.onChanged,
  });

  @override
  _SingleSelectDropdownState createState() => _SingleSelectDropdownState();
}

class _SingleSelectDropdownState extends State<SingleSelectDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initValue; // Initialen Wert setzen
  }

  // Funktion zum Auswählen eines Wertes
  void _selectValue(String value) {
    setState(() {
      _selectedValue = value; // Den ausgewählten Wert setzen
    });
    widget.onChanged(value); // Rückgabe des neuen Wertes
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
                  title: Text('Select Option'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.data.keys.map((option) {
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedValue, // Verknüpfung mit dem ausgewählten Wert
                          onChanged: (String? value) {
                            _selectValue(value!); // Wert auswählen
                            Navigator.of(context).pop(); // Dialog schließen
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dialog schließen ohne Auswahl
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
              hintText: _selectedValue ?? 'Please select an option', // Textanzeige der Auswahl
              border: OutlineInputBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_drop_down),
                  SizedBox(width: 8),
                  Text(
                    _selectedValue ?? 'Select option', // Anzeige der ausgewählten Option
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
