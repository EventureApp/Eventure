import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateAndTimePicker extends StatefulWidget {
  final String label;
  final String? initValue;
  final Function(DateTime) onDateChanged;
  final bool required;
  final bool editable;

  CustomDateAndTimePicker({
    required this.label,
    this.initValue,
    required this.required,
    required this.editable,
    required this.onDateChanged,
  });

  @override
  _CustomDateAndTimePickerState createState() =>
      _CustomDateAndTimePickerState();
}

class _CustomDateAndTimePickerState extends State<CustomDateAndTimePicker> {
  late TextEditingController _dateController;
  late DateTime _selectedDateTime;
  bool _isFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initValue != null
        ? DateFormat('yyyy-MM-dd HH:mm').parse(widget.initValue!)
        : DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime),
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
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
          _dateController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime);
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.required ? "${widget.label} *" : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (widget.editable) {
              _showDateTimePicker(context);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12.25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color:
                    _isFieldEmpty ? Colors.red : Colors.black.withOpacity(0.2),
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
                    _dateController.text.isEmpty
                        ? (widget.required
                            ? "Pflichtfeld"
                            : "Wählen Sie Datum und Uhrzeit")
                        : _dateController.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.black.withOpacity(0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_isFieldEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Dieses Feld ist erforderlich.',
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
