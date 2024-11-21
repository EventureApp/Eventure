import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateAndTimePicker extends StatefulWidget {
  final String label;
  final String? initValue;
  final Function(DateTime) onDateChanged; // Callback für ausgewählte Datum/Uhrzeit
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

  @override
  void initState() {
    super.initState();
    // Verwende initValue oder aktuelles Datum, falls initValue null ist
    _selectedDateTime = widget.initValue != null
        ? DateFormat('yyyy-MM-dd HH:mm').parse(widget.initValue!)
        : DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime),
    );
  }

  // CupertinoDatePicker in einer ModalBottomSheet anzeigen
  void _showCupertinoPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        DateTime tempSelectedDate = _selectedDateTime;
        return Container(
          height: 300,
          child: Column(
            children: [
              // Kopfzeile
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Select Date and Time",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  showDayOfWeek: true,
                  minimumDate: widget.editable ? DateTime.now() : null,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _selectedDateTime,
                  onDateTimeChanged: (dateTime) {
                    tempSelectedDate = dateTime;
                  },
                ),
              ),
              // Bestätigungsknopf
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDateTime = tempSelectedDate;
                    _dateController.text = DateFormat('yyyy-MM-dd HH:mm')
                        .format(_selectedDateTime);
                  });
                  widget.onDateChanged(_selectedDateTime);
                  Navigator.pop(context);
                },
                child: Text(
                  "Fertig",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.required ? widget.label + " *" :widget.label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _dateController,
          readOnly: true, // Bearbeitung im Textfeld verhindern, da Picker genutzt wird
          decoration: InputDecoration(
            hintText: widget.required ? 'Pflichtfeld' : 'Optional',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today), // Kalender-Icon
          ),
          onTap: () {
            if (widget.editable) {
              _showCupertinoPicker(context);
            }
          },
        ),
      ],
    );
  }
}
