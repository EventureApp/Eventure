import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/string_parser.dart';

class CustomDateAndTimePicker extends StatefulWidget {
  final String label;
  final DateTime? initValue;
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
  late FocusNode _focusNode; // Fokus-Node zum Überwachen des Fokus
  bool _isFieldEmpty = false; // Überprüft, ob das Feld leer ist

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initValue ?? DateTime.now();
    _dateController = TextEditingController(
      text: parseDateForEvents(_selectedDateTime),
    );
    _focusNode = FocusNode(); // Fokus-Node initialisieren

    // Fokus-Listener hinzufügen
    _focusNode.addListener(() {
      setState(() {}); // UI bei Fokusänderungen aktualisieren
    });
  }

  // Methode zum Öffnen des DateTime Pickers
  void _showDateTimePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: 'Select ${widget.label}',
      cancelText: 'Close',
      confirmText: 'Select',
      fieldHintText: 'Month/Day/Year',
      fieldLabelText: '${widget.label}',
      errorInvalidText: 'Please enter a valid date',
      errorFormatText: 'This is not the correct format',
      builder: (context, child) {
        return Theme(
          data : ThemeData(
          colorScheme: const ColorScheme.light(primary: const Color(0xFFB7CBDD)),
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: Colors.white,
            dividerColor: const Color(0xFFB7CBDD),
            headerBackgroundColor: const Color(0xFFB7CBDD),
            headerForegroundColor: Colors.white,
          ),
        ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        helpText: 'Select ${widget.label}-Time',
        cancelText: 'Close',
        confirmText: 'Select',
        errorInvalidText: 'Please enter a valid date',
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data : ThemeData(
              colorScheme: const ColorScheme.light(primary: const Color(0xFFB7CBDD)),
              timePickerTheme: const TimePickerThemeData(
                backgroundColor: Colors.white,
                hourMinuteColor: const Color(0xFFB7CBDD),
                dialHandColor: const Color(0xFFB7CBDD),
                dayPeriodColor: const Color(0xFFB7CBDD),
              ),
            ),
            child: child!,
          );
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
        });
        widget.onDateChanged(_selectedDateTime);
      }
    }
  }

  // Validierungslogik
  void _validateField(String value) {
    setState(() {
      _isFieldEmpty = widget.required && value.isEmpty;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _focusNode.dispose(); // Fokus-Node entladen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label mit optionalem Sternchen für Pflichtfelder
        Text.rich(
          TextSpan(
            text: widget.label.toUpperCase(), // Label immer in Großbuchstaben
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            children: widget.required
                ? [
                    const TextSpan(
                      text: " *", // Stern hinzufügen, wenn erforderlich
                      style: TextStyle(
                        color: Colors.red, // Stern in Rot
                      ),
                    ),
                  ]
                : [], // Kein Stern, wenn nicht erforderlich
          ),
        ),
        SizedBox(height: 8),
        // Container für den DateTime Picker
        GestureDetector(
          onTap: () {
            if (widget.editable) {
              _showDateTimePicker(context);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12.25),
            decoration: BoxDecoration(
              // Weiß, wenn nicht fokussiert
              borderRadius: BorderRadius.circular(2),
              // Leicht abgerundete Ecken
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).primaryColor
                    : _isFieldEmpty
                        ? Colors.red
                        : Colors.black.withOpacity(0.2),
                width: 1.5,
              ),
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
        // Fehlermeldung anzeigen, wenn das Feld erforderlich ist und leer bleibt
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
