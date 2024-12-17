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
  late FocusNode _focusNode; // FocusNode für das Eingabefeld
  bool _isFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initValue ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose(); // Fokus-Node freigeben
    super.dispose();
  }

  // Validation logic
  void _validateField(String value) {
    setState(() {
      _isFieldEmpty = widget.required && value.isEmpty;
    });
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
            ),
            children: widget.required
                ? [
                    const TextSpan(
                      text: " *", // Sternchen für Pflichtfelder
                      style: TextStyle(
                        color: Colors.red, // Stern in Rot
                      ),
                    ),
                  ]
                : [], // Kein Sternchen, wenn nicht erforderlich
          ),
        ),
        SizedBox(height: 8),

        // Eingabefeld für die Beschreibung
        GestureDetector(
          onTap: () {
            if (widget.editable) {
              // Zusätzliche Logik, wenn das Feld bearbeitbar ist
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), // Runde Ecken
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).colorScheme.secondary
                    : _isFieldEmpty
                        ? Colors.red
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: _textController,
              focusNode: _focusNode, // Fokus-Node für das TextField
              readOnly: !widget.editable,
              maxLines: 5, // Mehrzeiliges Textfeld
              decoration: InputDecoration(
                hintText: widget.required ? 'Mandatory' : 'Optional',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              onChanged: widget.editable
                  ? (value) {
                      widget.onChanged(value);
                      _validateField(value);
                    }
                  : null,
            ),
          ),
        ),

        // Fehlernachricht, wenn das Feld erforderlich und leer ist
        if (_isFieldEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'This field is mandatory.',
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
