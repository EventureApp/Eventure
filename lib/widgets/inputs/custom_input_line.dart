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
  late FocusNode _focusNode; // Fokus-Node zum Überwachen des Fokus
  bool _isFieldEmpty = false; // Überprüft, ob das Feld leer ist

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initValue ?? '');
    _focusNode = FocusNode(); // Fokus-Node initialisieren

    // Fokus-Listener hinzufügen
    _focusNode.addListener(() {
      setState(() {}); // UI bei Fokusänderungen aktualisieren
    });
  }

  // Validierungslogik
  void _validateField(String value) {
    setState(() {
      // Wenn das Feld erforderlich ist und leer bleibt, markieren wir es als "leer"
      _isFieldEmpty = widget.required && value.isEmpty;
    });
    widget.onChanged(value); // Rufe den Callback auf, um den Wert zu aktualisieren
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose(); // Fokus-Node entladen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label mit optionalem Sternchen für Pflichtfelder
        Text.rich(
          TextSpan(
            text: widget.label.toUpperCase(), // Label immer in Großbuchstaben
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black,
            ),
            children: widget.required
                ? [
              const TextSpan(
                text: " *", // Stern hinzufügen, wenn erforderlich
                style: TextStyle(
                  color: Colors.red, // Stern in Rot
                ),
              ),
            ]
                : [], // Kein Stern, wenn nicht erforderlich
          ),
        ),
        SizedBox(height: 5),
        // Eingabefeld ohne Icon, aber mit einem sauberen, modernen Design
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white, // Weiß, wenn nicht fokussiert
            borderRadius: BorderRadius.circular(2), // Leicht abgerundete Ecken
            border: Border.all(
              color:_focusNode.hasFocus ? Theme.of(context).primaryColor :  _isFieldEmpty ? Colors.red : Colors.black.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _textController,
            focusNode: _focusNode, // Fokus-Node an das Textfeld binden
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