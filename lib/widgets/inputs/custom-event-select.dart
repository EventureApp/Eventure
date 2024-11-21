import 'package:flutter/material.dart';

class EventSelect extends StatefulWidget {
  final String label;
  final List<String> initValues; // Initial ausgewählte Werte (Event Keys)
  final Map<String, IconData> events; // Map von Event-Keys zu Event-Icons (Icon Name oder Flutter-Icon)
  final Function(List<String>) onChanged; // Callback für Änderungen
  final bool isMultiSelect; // True für MultiSelect, False für SingleSelect

  EventSelect({
    required this.label,
    required this.initValues,
    required this.events,
    required this.onChanged,
    this.isMultiSelect = true, // Standardmäßig MultiSelect aktiv
  });

  @override
  _EventSelectState createState() => _EventSelectState();
}

class _EventSelectState extends State<EventSelect> {
  late List<String> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedEvents = List.from(widget.initValues); // Initialwerte setzen
  }

  // Methode zum Auswählen eines Events im MultiSelect-Modus
  void _toggleEventSelection(String eventKey) {
    if (widget.isMultiSelect) {
      setState(() {
        if (_selectedEvents.contains(eventKey)) {
          _selectedEvents.remove(eventKey); // Abwählen
        } else {
          _selectedEvents.add(eventKey); // Auswählen
        }
      });
    } else {
      setState(() {
        _selectedEvents = [eventKey]; // Nur das ausgewählte Event im SingleSelect-Modus
      });
    }
    widget.onChanged(_selectedEvents); // Rückgabe der ausgewählten Events
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
        GridView.builder(
          itemCount: widget.events.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 Icons pro Reihe
            crossAxisSpacing: 10.0, // Abstand zwischen den Icons
            mainAxisSpacing: 10.0, // Abstand zwischen den Reihen
          ),
          itemBuilder: (context, index) {
            String eventKey = widget.events.keys.elementAt(index);
            IconData eventIcon = widget.events[eventKey]!;

            bool isSelected = _selectedEvents.contains(eventKey); // Überprüfen, ob das Event ausgewählt wurde

            return GestureDetector(
              onTap: () => _toggleEventSelection(eventKey),
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      eventIcon, // Verwendet das Event-Icon aus der Map
                      size: 50,
                      color: isSelected ? Colors.blue : Colors.grey, // Farbänderung des Icons
                    ),
                    SizedBox(height: 8),
                    Text(
                      eventKey, // Anzeigen des Event-Namens
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black, // Farbänderung des Texts
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        // Anzeige der ausgewählten Events unter dem Label
        Text(
          'Selected Events:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10,
          children: _selectedEvents.map((eventKey) {
            return Chip(
              label: Text(eventKey),
              backgroundColor: Colors.blue.withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }
}
