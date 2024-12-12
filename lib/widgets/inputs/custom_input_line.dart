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
  bool _isFieldEmpty = false; // Checks if the field is empty

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initValue ?? '');
  }

  // Validation logic
  void _validateField(String value) {
    setState(() {
      // If the field is required and empty, mark it as "empty"
      _isFieldEmpty = widget.required && value.isEmpty;
    });
    widget.onChanged(value); // Call the callback to update the value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with an optional asterisk for required fields
        Text(
          widget.required ? widget.label + " *" : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16, // Consistent font size
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8), // Make sure the spacing here is consistent with other fields

        // Input field with clean, modern design
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Consistent padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),  // Slightly rounded corners
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
          child: TextFormField(
            controller: _textController,
            readOnly: !widget.editable,
            decoration: InputDecoration(
              hintText: widget.required ? 'Mandatory' : 'Optional',
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              border: InputBorder.none,
            ),
            onChanged: widget.editable ? _validateField : null,
          ),
        ),

        // Error message for required fields if empty
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
