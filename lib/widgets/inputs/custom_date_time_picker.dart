import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateAndTimePicker extends StatefulWidget {
  final String label;
  final String? initValue;
  final Function(DateTime) onDateChanged; // Callback für ausgewähltes Datum/Uhrzeit
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
    // Wenn initValue vorhanden ist, verwenden wir es, andernfalls das aktuelle Datum
    _selectedDateTime = widget.initValue != null
        ? DateFormat('yyyy-MM-dd HH:mm').parse(widget.initValue!)
        : DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime),
    );
  }

  // Funktion, um den PopOver zu öffnen und Datum und Uhrzeit auszuwählen
  void _showDateTimePicker(BuildContext context) async {
    // Datumsauswahl
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
            dialogBackgroundColor: Colors.white, // Weißer Hintergrund
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Zeit-Auswahl
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          // Kombiniere Datum und Uhrzeit
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime);
        });
        widget.onDateChanged(_selectedDateTime);
      }
    }
  }

  // Validierungslogik
  void _validateField(String value) {
    setState(() {
      // Wenn das Feld erforderlich ist und leer bleibt, markieren wir es als "leer"
      _isFieldEmpty = widget.required && value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label mit optionalem Sternchen für Pflichtfelder
        Text(
          widget.required ? widget.label + " *" : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400, // Einfache, klare Schriftart
            fontSize: 16,
            color: Colors.black, // Schwarzer Text für das Label
          ),
        ),
        SizedBox(height: 8),

        // Eingabefeld für Datum und Uhrzeit
        GestureDetector(
          onTap: () {
            if (widget.editable) {
              _showDateTimePicker(context);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14), // Weniger Padding für ein schmaleres Design
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isFieldEmpty ? Colors.red : Colors.black.withOpacity(0.2), // Wenn das Feld leer ist, wird es rot
                width: 1.5,
              ),boxShadow: [
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
                        ? (widget.required ? "Mandatory field" : "Select date and time")
                        : _dateController.text,
                    style: TextStyle(
                      color: Colors.black, // Schwarzer Text für Datum/Uhrzeit
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.black.withOpacity(0.3), // Subtiles Icon
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Fehlertext anzeigen, wenn das Feld leer ist und als "required" markiert
        if (_isFieldEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'This field is mandatory.',
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
