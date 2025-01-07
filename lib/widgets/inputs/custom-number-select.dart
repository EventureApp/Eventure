import 'package:flutter/material.dart';

class CustomNumberInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool? isMandatory;
  final int? minValue;
  final int? maxValue;
  final String? initValue;
  final Function(int?) onChanged;

  const CustomNumberInput({
    Key? key,
    required this.label,
    this.hint,
    this.isMandatory = false,
    this.minValue,
    this.maxValue,
    this.initValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomNumberInputState createState() => _CustomNumberInputState();
}

class _CustomNumberInputState extends State<CustomNumberInput> {
  String _errorMessage = "";
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.initValue ?? '';
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // Refresh UI on focus changes
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChange(String value) {
    if (value.isEmpty) {
      widget.onChanged(null);
      setState(() {
        _errorMessage =
            widget.isMandatory == true ? 'This field is mandatory.' : '';
      });
      return;
    }

    final number = int.tryParse(value);
    if (number == null) {
      setState(() {
        _errorMessage = 'Please enter a valid number.';
      });
      widget.onChanged(null);
      return;
    }

    if (widget.minValue != null && number < widget.minValue!) {
      setState(() {
        _errorMessage = 'Value must be >= ${widget.minValue}.';
      });
      widget.onChanged(null);
      return;
    }

    if (widget.maxValue != null && number > widget.maxValue!) {
      setState(() {
        _errorMessage = 'Value must be <= ${widget.maxValue}.';
      });
      widget.onChanged(null);
      return;
    }

    // If we reach here, the value is valid
    setState(() {
      _errorMessage = '';
    });
    widget.onChanged(number);
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final isInvalid = _errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          onChanged: _onChange,
          decoration: InputDecoration(
            labelText:
                widget.isMandatory == true ? '${widget.label} *' : widget.label,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
            hintText: widget.hint ??
                (widget.isMandatory == true ? 'Mandatory' : 'Optional'),
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.black26,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isInvalid ? Colors.red : Colors.black.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isInvalid ? Colors.red : Theme.of(context).colorScheme.secondary,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.secondary),
        ),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorMessage,
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
