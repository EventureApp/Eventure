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
  late FocusNode _focusNode; // FocusNode für das Eingabefeld

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode(); // Initialisieren des Fokus-Managements
    _focusNode.addListener(() {
      setState(() {}); // UI bei Fokusänderung aktualisieren
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Fokus-Node freigeben
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
          _errorMessage = 'Value must be >= ${widget.minValue}';
        });
        widget.onChanged(null);
      } else if (widget.maxValue != null && number > widget.maxValue!) {
        setState(() {
          _errorMessage = 'Value must be <= ${widget.maxValue}';
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
        // Label mit Sternchen für Pflichtfelder
        Text.rich(
          TextSpan(
            text: widget.label.toUpperCase(), // Label immer in Großbuchstaben
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black,
            ),
            children: widget.isMandatory!
                ? [
              const TextSpan(
                text: " *", // Sternchen für Pflichtfelder
                style: TextStyle(
                  color: Colors.red, // Stern in Rot
                ),
              ),
            ]
                : [], // Kein Sternchen, wenn nicht erforderlich
          ),
        ),
        SizedBox(height: 8),
        // Eingabefeld im angepassten Design
        GestureDetector(
          onTap: () {
            _focusNode.requestFocus(); // Fokus anfordern, wenn das Feld angetippt wird
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4), // Runde Ecken
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).primaryColor // Blau wenn fokussiert
                    : _errorMessage.isNotEmpty
                    ? Colors.red // Rot bei Fehler
                    : Colors.black.withOpacity(0.2), // Standardfarbe wenn nicht fokussiert
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
            child: TextField(
              controller: _controller,
              focusNode: _focusNode, // Fokus-Node für das TextField
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Enter a number',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              onChanged: _onChange,
            ),
          ),
        ),
        SizedBox(height: 8),
        // Fehlernachricht
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
