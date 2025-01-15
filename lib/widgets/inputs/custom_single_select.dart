import 'package:flutter/material.dart';

class SingleSelectDropdown extends StatefulWidget {
  final String label;
  final String? initValue;
  final Map<String, dynamic> data;
  final Function(String?) onChanged;
  final bool required;
  final bool editable;

  const SingleSelectDropdown({
    super.key,
    required this.label,
    this.initValue,
    required this.data,
    required this.onChanged,
    required this.required,
    required this.editable,
  });

  @override
  SingleSelectDropdownState createState() => SingleSelectDropdownState();
}

class SingleSelectDropdownState extends State<SingleSelectDropdown> {
  String? _selectedValue;
  bool _isFieldEmpty = false; // Similar to CustomInputLine
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initValue;
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openSelectionDialog() async {
    if (!widget.editable) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select ${widget.label}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.data.keys.map((option) {
                return RadioListTile<String>(
                  activeColor: Theme.of(context).primaryColor,
                  title: Text(option),
                  value: option,
                  groupValue: _selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedValue = value;
                      _isFieldEmpty =
                          widget.required && (value == null || value.isEmpty);
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
                setState(() {
                  _isFieldEmpty = widget.required && (_selectedValue == null || _selectedValue!.isEmpty);
                });
                Navigator.of(context).pop();
              },
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

  @override
  Widget build(BuildContext context) {

    String displayText = _selectedValue ??
        (widget.required ? 'Required field' : 'Select option');

    // Similar styling to CustomInputLine
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // If you want the label above the field (like CustomInputLine uses labelText), you can remove this Text.
        // However, CustomInputLine uses labelText in the InputDecoration. We'll mimic that exactly by using labelText below:
        // and remove this label widget entirely. If you want asterisks or additional styling, you could re-add it.

        // SizedBox(height: 8) - If you'd like some spacing before the field

        TextField(
          readOnly: true,
          focusNode: _focusNode,
          onTap: widget.editable ? _openSelectionDialog : null,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
            hintText: widget.required ? 'Mandatory' : 'Optional',
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: _focusNode.hasFocus ? Theme.of(context).colorScheme.secondary : Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color:
                    _isFieldEmpty ? Colors.red : Colors.black.withValues(alpha: 0.2),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color:Theme.of(context).colorScheme.secondary),
          controller: TextEditingController(text: displayText),
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
