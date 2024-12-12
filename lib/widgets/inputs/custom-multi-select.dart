import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String label;
  final List<String> initValues; // Initial ausgewählte Werte
  final Map<String, dynamic> data; // Die verfügbaren Optionen
  final Function(List<String>) onChanged; // Callback für Änderungen
  final bool required; // Hinzugefügte required-Option
  final bool editable; // Hinzugefügte editable-Option

  MultiSelectDropdown({
    required this.label,
    required this.initValues,
    required this.data,
    required this.onChanged,
    required this.required, // Pflichtfeld
    required this.editable, // Bearbeitbarkeit
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<String> selectedValues;
  String _errorMessage = ''; // Validierungsnachricht

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initValues); // Kopiere die initialen Werte
  }

  // Validierungsfunktion
  void _validate() {
    if (widget.required && selectedValues.isEmpty) {
      setState(() {
        _errorMessage = 'Bitte mindestens eine Auswahl treffen!';
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
        Row(
          children: [
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w400, // Einheitliche Schriftart
                fontSize: 16,
                color: Colors.black, // Schwarzer Text für das Label
              ),
            ),
            if (widget.required) ...[
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8),

        // Eingabefeld für die Auswahl
        GestureDetector(
          onTap: widget.editable ? () async {
            // Anzeigen eines modalen Dialogs mit den Auswahlmöglichkeiten
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Select ${widget.label}'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.data.keys.map((option) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return CheckboxListTile(
                              activeColor: Theme.of(context).primaryColor,
                              title: Text(option),
                              value: selectedValues.contains(option),
                              onChanged: widget.editable ? (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedValues.add(option);
                                  } else {
                                    selectedValues.remove(option);
                                  }
                                });
                                widget.onChanged(selectedValues);
                              } : null,
                            );
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
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8), // Abgerundete Ecken
              border: Border.all(
                color: _errorMessage.isNotEmpty
                    ? Colors.red
                    : Colors.black.withOpacity(0.2), // Randfarbe
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
                    selectedValues.isEmpty ?
                    (widget.required ? 'Pflichtfeld' : 'Select option') :
                    selectedValues.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.editable ? Colors.black : Colors.grey, // Textfarbe je nach Bearbeitbarkeit
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.editable ? Colors.black.withOpacity(0.3) : Colors.grey, // Icon Farbe
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
