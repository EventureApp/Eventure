import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomLinkInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool? isMandatory;
  final Function(String?) onChanged;

  const CustomLinkInput({
    Key? key,
    required this.label,
    this.hint,
    this.isMandatory = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomLinkInputState createState() => _CustomLinkInputState();
}

class _CustomLinkInputState extends State<CustomLinkInput> {
  String _errorMessage = "";
  late TextEditingController _controller;
  late FocusNode _focusNode; // FocusNode für das Eingabefeld

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode(); // Initialisieren des Fokus-Managements
    _focusNode.addListener(() {
      setState(() {}); // Aktualisieren der UI bei Fokusänderungen
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

    final isValidUrl = Uri.tryParse(value)?.hasAbsolutePath ?? false;
    if (isValidUrl) {
      setState(() {
        _errorMessage = '';
      });
      widget.onChanged(value);
    } else {
      setState(() {
        _errorMessage = 'Please enter a valid URL';
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
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).primaryColor // Blau wenn fokussiert
                    : _errorMessage.isNotEmpty
                    ? Colors.red // Rot bei Fehler
                    : Colors.black.withOpacity(0.2), // Standardfarbe wenn nicht fokussiert
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode, // Fokus-Node für das TextField
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Enter a link',
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
        // Link öffnen
        if (_errorMessage.isEmpty && _controller.text.isNotEmpty)
          GestureDetector(
            onTap: () async {
              final url = _controller.text;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                setState(() {
                  _errorMessage = 'Could not launch $url';
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Open link',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
