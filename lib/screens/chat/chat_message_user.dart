import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageUser extends StatelessWidget {
  final String message;

  const ChatMessageUser({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
