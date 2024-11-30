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
        // Label mit optionalem Sternchen für Pflichtfelder
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400, // Einheitliche Schriftart wie beim DateTimePicker
            fontSize: 16,
            color: Colors.black, // Schwarzer Text für das Label
          ),
        ),
        SizedBox(height: 8),

        // Eingabefeld für die Auswahl
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
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return CheckboxListTile(
                              title: Text(option),
                              value: selectedValues.contains(option), // Überprüfe, ob der Wert ausgewählt ist
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedValues.add(option); // Wert hinzufügen
                                  } else {
                                    selectedValues.remove(option); // Wert entfernen
                                  }
                                });
                                widget.onChanged(selectedValues); // Rückgabe der neuen Liste
                              },
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
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
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
                    selectedValues.isEmpty
                        ? 'Select options'
                        : selectedValues.join(', '), // Anzeige der ausgewählten Optionen
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Schwarzer Text für die Anzeige der Auswahl
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black.withOpacity(0.3), // Subtiles Icon
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
