import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String label;
  final List<String> initValues; // Initially selected values
  final Map<String, dynamic> data; // The available options
  final Function(List<String>) onChanged; // Callback for changes
  final bool required; // Mandatory field
  final bool editable; // Whether it's editable or not

  const MultiSelectDropdown({
    super.key,
    required this.label,
    required this.initValues,
    required this.data,
    required this.onChanged,
    required this.required,
    required this.editable,
  });

  @override
  MultiSelectDropdownState createState() => MultiSelectDropdownState();
}

class MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<String> selectedValues;
  bool _hasAttemptedSubmit = false;
  late FocusNode _focusNode;

  bool get _hasError {
    return widget.required && selectedValues.isEmpty && _hasAttemptedSubmit;
  }

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initValues);
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

  Future<void> _openSelectionDialog() async {
    if (!widget.editable) return;

    // Temporary copy of selection to allow canceling changes
    List<String> tempSelection = List.from(selectedValues);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Select ${widget.label}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.data.keys.map((option) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) {
                    final isSelected = tempSelection.contains(option);
                    return CheckboxListTile(
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(option),
                      value: isSelected,
                      onChanged: widget.editable
                          ? (bool? value) {
                              setStateDialog(() {
                                if (value == true) {
                                  tempSelection.add(option);
                                } else {
                                  tempSelection.remove(option);
                                }
                              });
                            }
                          : null,
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Confirm selection
                setState(() {
                  selectedValues = tempSelection;
                });
                widget.onChanged(selectedValues);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    setState(() {}); // Refresh UI after dialog is closed
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1976D2);
    final isFocused = _focusNode.hasFocus;

    // If empty and mandatory, show "Mandatory" hint, else "Optional"
    final hintText = widget.required ? 'Mandatory' : 'Optional';

    // Display either the selected values or the hint
    final displayText =
        selectedValues.isEmpty ? hintText : selectedValues.join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: true,
          focusNode: _focusNode,
          onTap: () async {
            await _openSelectionDialog();
            setState(() {
              _hasAttemptedSubmit = true;
            });
          },
          decoration: InputDecoration(
            labelText: widget.required ? '${widget.label} *' : widget.label,
            labelStyle: TextStyle(
              color: isFocused ? primaryColor : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: isFocused ? primaryColor : Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black26, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError ? Colors.red : Colors.black.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError ? Colors.red : primaryColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          controller: TextEditingController(text: displayText),
        ),
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'At least one selection is required.',
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
