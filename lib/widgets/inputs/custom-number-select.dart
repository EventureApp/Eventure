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
          _errorMessage = 'Value must be greater than or equal to ${widget.minValue}';
        });
        widget.onChanged(null);
      } else if (widget.maxValue != null && number > widget.maxValue!) {
        setState(() {
          _errorMessage = 'Value must be less than or equal to ${widget.maxValue}';
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
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.isMandatory!)
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hint ?? 'Enter a number',
            errorText: _errorMessage.isEmpty ? null : _errorMessage,
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: _onChange,
        ),
      ],
    );
  }
}
