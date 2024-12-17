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
  late FocusNode _focusNode;

  bool get _isEmpty => _controller.text.isEmpty;
  bool get _hasError => _errorMessage.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChange(String value) {
    if (value.isEmpty) {
      // Empty value
      widget.onChanged(null);
      setState(() {
        _errorMessage = widget.isMandatory! ? 'This field is required.' : '';
      });
      return;
    }

    // Validate URL format
    final uri = Uri.tryParse(value);
    if (uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https')) {
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

  Future<void> _openLink() async {
    final url = _controller.text.trim();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      setState(() {
        _errorMessage = 'Could not launch $url';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1976D2);
    final isFocused = _focusNode.hasFocus;
    final isError = _hasError;

    // Determine hint text: If user provided a hint, use it, otherwise show Mandatory/Optional
    final hintText =
        widget.hint ?? (widget.isMandatory == true ? 'Mandatory' : 'Optional');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onChange,
          decoration: InputDecoration(
            labelText:
                widget.isMandatory == true ? '${widget.label} *' : widget.label,
            labelStyle: TextStyle(
              color: isFocused ? primaryColor : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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
                color: isError ? Colors.red : Colors.black.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isError ? Colors.red : primaryColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            ),
          ),
        // Show the "Open link" option if there's no error, not empty, and a valid URL entered
        if (!_isEmpty && !isError)
          GestureDetector(
            onTap: _openLink,
            child: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Open link',
                style: TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
