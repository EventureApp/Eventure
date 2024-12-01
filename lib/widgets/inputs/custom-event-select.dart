import 'package:flutter/material.dart';
import 'package:eventure/statics/event_types.dart';

class EventSelect extends StatefulWidget {
  final String label;
  final List<EventType> initValues; // Initial ausgewählte Werte (EventType-Enum)
  final Map<EventType, IconData> events; // Map von Event-Keys zu Event-Icons
  final Function(List<EventType>) onChanged; // Callback für Änderungen
  final bool isMultiSelect; // True für MultiSelect, False für SingleSelect
  final bool isMandatory; // Gibt an, ob das Feld Pflicht ist
  final bool isEditable; // Gibt an, ob das Feld bearbeitbar ist

  EventSelect({
    required this.label,
    required this.initValues,
    required this.events,
    required this.onChanged,
    this.isMultiSelect = true, // Standardmäßig MultiSelect aktiv
    this.isMandatory = false, // Standardmäßig kein Pflichtfeld
    this.isEditable = true, // Standardmäßig bearbeitbar
  });

  @override
  _EventSelectState createState() => _EventSelectState();
}

class _EventSelectState extends State<EventSelect> {
  late List<EventType> _selectedEvents;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _selectedEvents = List.from(widget.initValues); // Initialwerte setzen
  }

  // Methode zum Auswählen eines Events im MultiSelect-Modus
  void _toggleEventSelection(EventType event) {
    if (!widget.isEditable) return; // Keine Änderungen, wenn nicht bearbeitbar

    if (widget.isMultiSelect) {
      setState(() {
        if (_selectedEvents.contains(event)) {
          _selectedEvents.remove(event); // Abwählen
        } else {
          _selectedEvents.add(event); // Auswählen
        }
      });
    } else {
      setState(() {
        _selectedEvents = [event]; // Nur das ausgewählte Event im SingleSelect-Modus
      });
    }
    widget.onChanged(_selectedEvents); // Rückgabe der ausgewählten Events
  }

  // Validierung für Pflichtfelder
  void _validateSelection() {
    if (widget.isMandatory && _selectedEvents.isEmpty) {
      setState(() {
        _errorMessage = "At least one event must be selected.";
      });
    } else {
      setState(() {
        _errorMessage = "";
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
          widget.isMandatory ? '${widget.label} *' : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),

        // Grid-Ansicht für Event-Icons und Namen
        GridView.builder(
          itemCount: widget.events.length,
          shrinkWrap: true, // Wird in vielen Fällen benötigt, um das Grid ohne Scrollen anzuzeigen
          physics: NeverScrollableScrollPhysics(), // Verhindert das Scrollen innerhalb des Grids
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 Icons pro Reihe
            crossAxisSpacing: 10.0, // Abstand zwischen den Icons
            mainAxisSpacing: 10.0, // Abstand zwischen den Reihen
          ),
          itemBuilder: (context, index) {
            EventType eventKey = widget.events.keys.elementAt(index);
            IconData eventIcon = widget.events[eventKey]!;

            bool isSelected = _selectedEvents.contains(eventKey); // Überprüfen, ob das Event ausgewählt wurde

            return GestureDetector(
              onTap: widget.isEditable
                  ? () => _toggleEventSelection(eventKey)
                  : null, // Deaktivieren der Tap-Funktion, wenn nicht bearbeitbar
              child: Opacity(
                opacity: widget.isEditable ? 1.0 : 0.5, // Reduzierte Sichtbarkeit, wenn nicht bearbeitbar
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      eventIcon, // Verwendet das Event-Icon aus der Map
                      size: 50,
                      color: isSelected ? Colors.blue : Colors.grey, // Farbänderung des Icons
                    ),
                    SizedBox(height: 8),
                    Text(
                      eventKey.toString().split('.').last, // Anzeige des Event-Namens aus dem Enum
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.blue : Colors.black, // Farbänderung des Texts
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 8),

        // Fehlermeldung für Pflichtfelder
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
