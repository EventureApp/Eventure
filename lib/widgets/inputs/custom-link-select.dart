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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        Text(
          widget.isMandatory! ? '${widget.label} *' : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Eingabefeld im angepassten Design
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _errorMessage.isNotEmpty ? Colors.red : Colors.black.withOpacity(0.2),
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
