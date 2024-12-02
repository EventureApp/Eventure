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

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initValue ?? '');
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
            fontWeight: FontWeight.w400, // Einheitliche Schriftart wie beim DateTimePicker
            fontSize: 16,
            color: Colors.black, // Schwarzer Text für das Label
          ),
        ),
        SizedBox(height: 8),

        // Eingabefeld im gleichen Design wie der DateTimePicker
        GestureDetector(
          onTap: () {
            if (widget.editable) {
              // Hier könnte zusätzliches Verhalten hinzugefügt werden, wenn benötigt
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4), // Abgerundete Ecken
              border: Border.all(
                color: Colors.black.withOpacity(0.2), // Subtile Ränder ohne auffällige Farben
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Subtiler Schatten für Tiefe
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    readOnly: !widget.editable,
                    decoration: InputDecoration(
                      hintText: widget.required ? 'Pflichtfeld' : 'Optional',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600, // Grauer Hinweistext
                        fontSize: 14,
                      ),
                      border: InputBorder.none, // Kein Border von InputDecoration
                    ),
                    onChanged: widget.editable
                        ? (value) => widget.onChanged(value)
                        : null, // Callback nur bei Editierbarkeit
                  ),
                ),
                Icon(
                  Icons.edit, // Optionales Bearbeitungs-Icon
                  color: widget.editable ? Colors.black : Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
