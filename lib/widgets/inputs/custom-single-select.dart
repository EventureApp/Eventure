import 'package:flutter/material.dart';

class SingleSelectDropdown extends StatefulWidget {
  final String label;
  final String? initValue;
  final Map<String, dynamic> data;
  final Function(String?) onChanged;
  final bool required;
  final bool editable;

  SingleSelectDropdown({
    required this.label,
    this.initValue,
    required this.data,
    required this.onChanged,
    required this.required,
    required this.editable,
  });

  @override
  _SingleSelectDropdownState createState() => _SingleSelectDropdownState();
}

class _SingleSelectDropdownState extends State<SingleSelectDropdown> {
  String? _selectedValue;
  String _errorMessage = '';
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _selectedValue = null; // No initial value selected
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _validate() {
    if (widget.required && _selectedValue == null) {
      setState(() {
        _errorMessage = 'Please make a selection!';
      });
    } else {
      setState(() {
        _errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional asterisk for required fields
        Row(
          children: [
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            if (widget.required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        SizedBox(height: 8),

        // Dropdown input field
        GestureDetector(
          onTap: widget.editable
              ? () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Select ${widget.label}'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: widget.data.keys.map((option) {
                        return RadioListTile<String>(
                          activeColor: Theme.of(context).primaryColor,
                          title: Text(option),
                          value: option,
                          groupValue: _selectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedValue = value;
                              _errorMessage = '';
                            });
                            widget.onChanged(value);
                            Navigator.of(context).pop();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12.25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedValue ??
                        'Select option', // Placeholder text
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedValue == null
                          ? Colors.grey // Placeholder text color
                          : Theme.of(context).colorScheme.onSurface, // Selected value color
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.editable
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.6)
                      : Colors.grey,
                ),
              ],
            ),
          ),
        ),
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
