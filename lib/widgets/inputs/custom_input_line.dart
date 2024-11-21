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
        Text(
          widget.required ? "${widget.label} *" : widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _textController,
          readOnly: !widget.editable,
          decoration: InputDecoration(
            hintText: widget.required ? 'Pflichtfeld' : 'Optional',
            border: OutlineInputBorder(),
          ),
          onChanged: widget.editable
              ? (value) => widget.onChanged(value)
              : null, // Callback nur bei Editierbarkeit
        ),
      ],
    );
  }
}
