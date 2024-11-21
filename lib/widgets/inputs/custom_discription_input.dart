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
          maxLines: 5, // Mehrzeiliges Textfeld
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
