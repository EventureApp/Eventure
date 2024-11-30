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
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.isMandatory!)
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hint ?? 'Enter a link',
            errorText: _errorMessage.isEmpty ? null : _errorMessage,
            border: OutlineInputBorder(),
          ),
          onChanged: _onChange,
        ),
        SizedBox(height: 8),
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
            child: Text(
              'Open link',
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }
}
