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
  String _errorMessage = ''; // Validierungsnachricht

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initValue; // Initialen Wert setzen
  }

  // Validierungsfunktion
  void _validate() {
    if (widget.required && _selectedValue == null) {
      setState(() {
        _errorMessage = 'Bitte eine Auswahl treffen!';
      });
    } else {
      setState(() {
        _errorMessage = ''; // Fehler zurücksetzen, wenn gültig
      });
    }
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
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black, // Schwarz für das Label
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
                          groupValue: _selectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedValue = value;
                              _errorMessage = ''; // Fehler zurücksetzen
                            });
                            widget.onChanged(value); // Rückgabe des neuen Wertes
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
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.black.withOpacity(0.2), // Schwarz für den Rand
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                  color: widget.editable ? Colors.black.withOpacity(0.3) : Colors.grey, // Blau für aktive Dropdowns
                ),
              ],
            ),
          ),
        ),
        // Fehlernachricht
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red, // Rote Farbe für Fehlermeldungen
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}