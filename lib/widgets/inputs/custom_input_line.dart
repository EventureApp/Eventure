import 'package:flutter/material.dart';

class CustomInputLine extends StatefulWidget {
  final String label;
  final String? initValue;
  final bool required;
  final bool editable;
  final Function(String) onChanged;
  final IconData? prefixIcon; // Optionaler Icon-Parameter
  final String? hintText;

  const CustomInputLine({
    Key? key,
    required this.label,
    this.initValue,
    required this.required,
    required this.editable,
    required this.onChanged,
    this.prefixIcon,
    this.hintText,
  }) : super(key: key);

  @override
  _CustomInputLineState createState() => _CustomInputLineState();
}

class _CustomInputLineState extends State<CustomInputLine> {
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

  void _validateField(String value) {
    setState(() {
      _isFieldEmpty = widget.required && value.isEmpty;
    });
    widget.onChanged(value);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF1976D2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: _textController,
          focusNode: _focusNode,
          readOnly: !widget.editable,
          onChanged: widget.editable ? _validateField : null,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _focusNode.hasFocus ? Colors.white : Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
            hintText:
                widget.hintText ?? (widget.required ? 'Mandatory' : 'Optional'),
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon,
                    color: _focusNode.hasFocus ? primaryColor : Colors.grey)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.2),
                width: 1.5,
              ),
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
                color: Theme.of(context).colorScheme.secondary,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: Theme.of(context).colorScheme.secondary),
        ),
        if (_isFieldEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'This field is required.',
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
