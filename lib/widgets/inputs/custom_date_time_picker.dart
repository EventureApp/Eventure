import 'package:flutter/material.dart';

import '../../utils/string_parser.dart';

class CustomDateAndTimePicker extends StatefulWidget {
  final String label;
  final DateTime? initValue;
  final Function(DateTime) onDateChanged;
  final bool required;
  final bool editable;

  const CustomDateAndTimePicker({
    super.key,
    required this.label,
    this.initValue,
    required this.required,
    required this.editable,
    required this.onDateChanged,
  });

  @override
  CustomDateAndTimePickerState createState() =>
      CustomDateAndTimePickerState();
}

class CustomDateAndTimePickerState extends State<CustomDateAndTimePicker> {
  late TextEditingController _dateController;
  late FocusNode _focusNode;
  bool _isFieldEmpty = false;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initValue ?? DateTime.now();
    _dateController = TextEditingController(
      text:
          widget.initValue != null ? parseDateForEvents(widget.initValue!) : '',
    );
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  void _showDateTimePicker() async {
    if (!widget.editable) return;

    DateTime initialDate = _selectedDateTime;
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select ${widget.label}',
      cancelText: 'Close',
      confirmText: 'Select',
      fieldHintText: 'Month/Day/Year',
      fieldLabelText: widget.label,
      errorInvalidText: 'Please enter a valid date',
      errorFormatText: 'Invalid format',
      builder: (context, child) {
        // Style the date picker if desired
        return child!;
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        helpText: 'Select ${widget.label} Time',
        cancelText: 'Close',
        confirmText: 'Select',
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          // Style the time picker if desired
          return child!;
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text = parseDateForEvents(_selectedDateTime);
          _validateField(_dateController.text);
        });
        widget.onDateChanged(_selectedDateTime);
      }
    }
  }

  void _validateField(String value) {
    setState(() {
      _isFieldEmpty = widget.required && value.isEmpty;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final isError = _isFieldEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _dateController,
          focusNode: _focusNode,
          readOnly: true,
          onTap: _showDateTimePicker,
          decoration: InputDecoration(
            labelText: widget.required ? '${widget.label} *' : widget.label,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
            hintText: widget.required ? 'Mandatory' : 'Optional',
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: isFocused ? Theme.of(context).colorScheme.secondary : Colors.grey,
            ),
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
                color: isError ? Colors.red : Colors.black.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isError ? Colors.red : Theme.of(context).colorScheme.secondary,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        if (isError)
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
