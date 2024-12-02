import 'package:flutter/material.dart';

class CustomNumberInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool? isMandatory;
  final int? minValue;
  final int? maxValue;
  final Function(int?) onChanged;

  const CustomNumberInput({
    Key? key,
    required this.label,
    this.hint,
    this.isMandatory = false,
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChange(String value) {
    if (value.isEmpty) {
      widget.onChanged(null);
      setState(() {
        _errorMessage = widget.isMandatory! ? 'This field is mandatory.' : '';
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
        // Label
        Text(
          widget.isMandatory! ? '${widget.label} *' : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Eingabefeld
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _errorMessage.isNotEmpty ? Colors.red : Colors.black.withOpacity(0.2), // Fehlerfarbe
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
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
              // Fehlernachricht
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
          ),
        ),
      ],
    );
  }
}
