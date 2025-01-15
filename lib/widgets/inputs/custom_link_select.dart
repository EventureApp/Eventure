import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomLinkInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool? isMandatory;
  final Function(String?) onChanged;

  const CustomLinkInput({
    super.key,
    required this.label,
    this.hint,
    this.isMandatory = false,
    required this.onChanged,
  });

  @override
  CustomLinkInputState createState() => CustomLinkInputState();
}

class CustomLinkInputState extends State<CustomLinkInput> {
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
    final urlText = _controller.text.trim();
    final Uri url = Uri.parse(urlText);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
      );
    } else {
      setState(() {
        _errorMessage = 'Could not launch $url';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).colorScheme.secondary,
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
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.secondary),
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
                  color: Colors.blue,
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
