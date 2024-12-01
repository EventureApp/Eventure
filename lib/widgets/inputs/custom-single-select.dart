import 'package:flutter/material.dart';

class SingleSelectDropdown extends StatefulWidget {
  final String label;
  final String? initValue; // Initialer Wert
  final Map<String, dynamic> data; // Die verfügbaren Optionen
  final Function(String?) onChanged; // Callback für Änderungen
  final bool required; // Hinzugefügte required-Option
  final bool editable; // Hinzugefügte editable-Option

  SingleSelectDropdown({
    required this.label,
    this.initValue,
    required this.data,
    required this.onChanged,
    required this.required, // Pflichtfeld
    required this.editable, // Bearbeitbarkeit
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
        // Label mit optionalem Sternchen für Pflichtfelder
        Text(
          widget.required ? "${widget.label} *" : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400, // Einheitliche Schriftart wie beim DateTimePicker
            fontSize: 16,
            color: Colors.black, // Schwarzer Text für das Label
          ),
        ),
        SizedBox(height: 8),

        // Dropdown-Eingabefeld
        GestureDetector(
          onTap: widget.editable ? () async {
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
          } : null, // Nur wenn editable true ist
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4), // Abgerundete Ecken
              border: Border.all(
                color: Colors.black.withOpacity(0.2), // Subtile Ränder
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Subtiler Schatten
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedValue ?? (widget.required ? 'Pflichtfeld' : 'Select option'),
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.editable ? Colors.black : Colors.grey, // Textfarbe je nach Bearbeitbarkeit
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.editable ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.3), // Icon nur aktiv bei editable
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
