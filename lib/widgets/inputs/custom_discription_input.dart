import 'package:flutter/material.dart';

class CustomDescriptionInput extends StatefulWidget {
  final String label;
  final String? initValue;
  final bool required;
  final bool editable;
  final Function(String) onChanged;

  CustomDescriptionInput({
    required this.label,
    this.initValue,
    required this.required,
    required this.editable,
    required this.onChanged,
  });

  @override
  _CustomDescriptionInputState createState() => _CustomDescriptionInputState();
}

class _CustomDescriptionInputState extends State<CustomDescriptionInput> {
  late TextEditingController _textController;
  bool _isFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initValue ?? '');
  }

  // Validierungslogik
  void _validateField(String value) {
    setState(() {
      // Wenn das Feld erforderlich ist und leer bleibt, markieren wir es als "leer"
      _isFieldEmpty = widget.required && value.isEmpty;
    });
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
            fontWeight: FontWeight.w400, // Einheitliche Schriftart
            fontSize: 16,
            color: Colors.black, // Schwarzer Text für das Label
          ),
        ),
        SizedBox(height: 8),

        // Eingabefeld für die Beschreibung
        GestureDetector(
          onTap: () {
            if (widget.editable) {
              // Hier könnte zusätzliches Verhalten hinzugefügt werden
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14), // Weniger Padding für ein schmaleres Design
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4), // Abgerundete Ecken
              border: Border.all(
                color: _isFieldEmpty ? Colors.red : Colors.black.withOpacity(0.2), // Rot, wenn leer
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: _textController,
              readOnly: !widget.editable,
              maxLines: 5, // Mehrzeiliges Textfeld
              decoration: InputDecoration(
                hintText: widget.required ? 'Pflichtfeld' : 'Optional',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600, // Grauer Hinweistext
                  fontSize: 14,
                ),
                border: InputBorder.none, // Kein Border von InputDecoration
              ),
              onChanged: widget.editable
                  ? (value) {
                widget.onChanged(value); // Callback nur bei Editierbarkeit
                _validateField(value); // Validierung durchführen
              }
                  : null,
            ),
          ),
        ),

        // Fehlertext anzeigen, wenn das Feld leer ist und als "required" markiert
        if (_isFieldEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Dieses Feld ist erforderlich.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
