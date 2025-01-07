import 'package:flutter/material.dart';

class CustomDescriptionInput extends StatefulWidget {
  final String label;
  final String? initValue;
  final bool required;
  final bool editable;
  final Function(String) onChanged;

  const CustomDescriptionInput({
    Key? key,
    required this.label,
    this.initValue,
    required this.required,
    required this.editable,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDescriptionInputState createState() => _CustomDescriptionInputState();
}

class _CustomDescriptionInputState extends State<CustomDescriptionInput> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
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
    _focusNode.dispose();
    super.dispose();
  }

  void _validateField(String value) {
    setState(() {
      _isFieldEmpty = widget.required && value.isEmpty;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _textController,
          focusNode: _focusNode,
          readOnly: !widget.editable,
          maxLines: 5, // Supports multiple lines
          onChanged: widget.editable ? _validateField : null,
          decoration: InputDecoration(
            labelText: widget.required ? '${widget.label} *' : widget.label,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
            hintText: widget.required ? 'Mandatory' : 'Optional',
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black26, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color:
                    _isFieldEmpty ? Colors.red : Colors.black.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isFieldEmpty ? Colors.red : Theme.of(context).colorScheme.secondary,
                width: 1.5,
              ),
            ),
          ),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.secondary),
        ),
        if (_isFieldEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'This field is mandatory.',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
