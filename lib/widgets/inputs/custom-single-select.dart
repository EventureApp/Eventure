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

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initValue;
  }

  void _validate() {
    if (widget.required && _selectedValue == null) {
      setState(() {
        _errorMessage = 'Bitte eine Auswahl treffen!';
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
        Text(
          widget.required ? "${widget.label} *" : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
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
                        title: Text('Select Option'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.data.keys.map((option) {
                              return RadioListTile<String>(
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
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
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
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(8), // Match the rounded corners
              border: Border.all(
                color: _errorMessage.isNotEmpty
                    ? Colors.red
                    : Colors.black.withOpacity(0.2),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedValue ??
                        (widget.required ? 'Pflichtfeld' : 'Select option'),
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.editable ? Colors.black : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.editable
                      ? Colors.black.withOpacity(0.3)
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
