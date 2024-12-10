import 'package:flutter/material.dart';

class CustomInputLine extends StatefulWidget {
  final String label;
  final String? initValue;
  final bool required;
  final bool editable;
  final Function(String) onChanged;

  CustomInputLine({
    required this.label,
    this.initValue,
    required this.required,
    required this.editable,
    required this.onChanged,
  });

  @override
  _CustomInputLineState createState() => _CustomInputLineState();
}

class _CustomInputLineState extends State<CustomInputLine> {
  late TextEditingController _textController;
  bool _isFieldEmpty = false; // Überprüft, ob das Feld leer ist

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
    widget.onChanged(
        value); // Rufe den Callback auf, um den Wert zu aktualisieren
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label mit optionalem Sternchen für Pflichtfelder
        Text(
          widget.required ? widget.label + " *" : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),

        // Eingabefeld ohne Icon, aber mit einem sauberen, modernen Design
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8), // Leicht abgerundete Ecken
            border: Border.all(
              color: _isFieldEmpty ? Colors.red : Colors.black.withOpacity(0.2),
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
          child: TextField(
            controller: _textController,
            readOnly: !widget.editable,
            decoration: InputDecoration(
              hintText: widget.required ? 'Pflichtfeld' : 'Optional',
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              border: InputBorder.none,
            ),
            onChanged: widget.editable ? _validateField : null,
          ),
        ),

        // Wenn das Feld erforderlich ist und leer bleibt, Fehlermeldung anzeigen
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
