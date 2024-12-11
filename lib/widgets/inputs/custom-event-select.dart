import 'package:eventure/statics/event_types.dart';
import 'package:flutter/material.dart';

class EventSelect extends StatefulWidget {
  final String label;
  final List<EventType>
      initValues; // Initial ausgewählte Werte (EventType-Enum)
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

    setState(() {
      if (widget.isMultiSelect) {
        if (_selectedEvents.contains(event)) {
          _selectedEvents.remove(event); // Abwählen
        } else {
          _selectedEvents.add(event); // Auswählen
        }
      } else {
        _selectedEvents = [
          event
        ]; // Nur das ausgewählte Event im SingleSelect-Modus
      }
    });
    widget.onChanged(_selectedEvents); // Rückgabe der ausgewählten Events
  }

  // Methode zum Entfernen eines Events
  void _removeEvent(EventType event) {
    setState(() {
      _selectedEvents.remove(event);
      widget.onChanged(_selectedEvents); // Rückgabe der neuen Liste
    });

    // Validierung auslösen, wenn SingleSelect und Pflichtfeld
    if (!widget.isMultiSelect &&
        widget.isMandatory &&
        _selectedEvents.isEmpty) {
      setState(() {
        _errorMessage = "At least one event must be selected.";
      });
    }
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

  // Anzeige der Chips für ausgewählte Events
  Widget _buildSelectedEvents() {
    return Wrap(
      spacing: 8.0,
      children: _selectedEvents.map((event) {
        return Chip(
          label: Text(event.toString().split('.').last),
          deleteIcon: Icon(Icons.close),
          onDeleted: () => _removeEvent(event), // Entfernen eines Events
        );
      }).toList(),
    );
  }

  // Öffnen des Popovers mit den Event-Icons
  void _openEventPopover() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Events',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        itemCount: widget.events.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 Icons pro Reihe
                          crossAxisSpacing: 10.0, // Abstand zwischen den Icons
                          mainAxisSpacing: 10.0, // Abstand zwischen den Reihen
                        ),
                        itemBuilder: (context, index) {
                          EventType eventKey =
                              widget.events.keys.elementAt(index);
                          IconData eventIcon = widget.events[eventKey]!;

                          bool isSelected = _selectedEvents.contains(
                              eventKey); // Überprüfen, ob das Event ausgewählt wurde

                          return GestureDetector(
                            onTap: widget.isEditable
                                ? () {
                                    setState(() {
                                      _toggleEventSelection(eventKey);
                                    });
                                  }
                                : null,
                            // Deaktivieren der Tap-Funktion, wenn nicht bearbeitbar
                            child: Opacity(
                              opacity: widget.isEditable ? 1.0 : 0.5,
                              // Reduzierte Sichtbarkeit, wenn nicht bearbeitbar
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    eventIcon,
                                    // Verwendet das Event-Icon aus der Map
                                    size: 40, // Angepasste Größe
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey, // Farbänderung des Icons
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    eventKey.toString().split('.').last,
                                    // Anzeige des Event-Namens aus dem Enum
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors
                                              .black, // Farbänderung des Texts
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dialog schließen
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label mit optionalem Sternchen für Pflichtfelder und dem + Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isMandatory ? '${widget.label} *' : widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            if (widget.isEditable)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _openEventPopover, // Popover öffnen
                color: Colors.blue,
              ),
          ],
        ),
        SizedBox(height: 8),

        // Anzeige der ausgewählten Events unter dem Label
        if (_selectedEvents.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: _buildSelectedEvents(),
          ),

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
