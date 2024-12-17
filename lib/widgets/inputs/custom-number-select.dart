import 'package:flutter/material.dart';

class CustomNumberInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required; // Changed isMandatory to required
  final int? minValue;
  final int? maxValue;
  final Function(int?) onChanged;

  const CustomNumberInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false, // Default value remains false
    this.minValue,
    this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomNumberInputState createState() => _CustomNumberInputState();
}

class _CustomNumberInputState extends State<CustomNumberInput> {
  String _errorMessage = "";
  late TextEditingController _controller;
  late FocusNode _focusNode; // FocusNode for managing focus

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // Update UI when focus changes
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Clean up focus node
    super.dispose();
  }

  void _onChange(String value) {
    if (value.isEmpty) {
      widget.onChanged(null);
      setState(() {
        _errorMessage = widget.required ? 'This field is required.' : '';
      });
      return;
    }

    final number = int.tryParse(value);
    if (number != null) {
      if (widget.minValue != null && number < widget.minValue!) {
        setState(() {
          _errorMessage = 'Value must be >= ${widget.minValue}';
        });
        widget.onChanged(null);
      } else if (widget.maxValue != null && number > widget.maxValue!) {
        setState(() {
          _errorMessage = 'Value must be <= ${widget.maxValue}';
        });
        widget.onChanged(null);
      } else {
        setState(() {
          _errorMessage = '';
        });
        widget.onChanged(number);
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter a valid number';
      });
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with an asterisk for required fields
        Text.rich(
          TextSpan(
            text: widget.label.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            children: widget.required
                ? [
              const TextSpan(
                text: " *",
                style: TextStyle(
                  color: Colors.red, // Red asterisk for required fields
                ),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 8),
        // Input Field
        GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).colorScheme.secondary
                    : _errorMessage.isNotEmpty
                    ? Colors.red
                    : Theme.of(context)
                    .colorScheme
                    .secondary
                    .withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Enter a number',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              onChanged: _onChange,
            ),
          ),
        ),
        SizedBox(height: 8),
        // Error Message
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorMessage,
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
