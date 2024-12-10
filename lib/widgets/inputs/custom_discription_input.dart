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
        // Label with optional asterisk for required fields
        Text(
          widget.required ? "${widget.label} *" : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),

        // Input field for description
        GestureDetector(
          onTap: () {
            if (widget.editable) {
              // Additional behavior can be added here
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(8), // Match the rounded corners
              border: Border.all(
                color:
                    _isFieldEmpty ? Colors.red : Colors.black.withOpacity(0.2),
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
              maxLines: 5, // Multiline text field
              decoration: InputDecoration(
                hintText: widget.required ? 'Pflichtfeld' : 'Optional',
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

        // Error message if the field is required and empty
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
