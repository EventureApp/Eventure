import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageGroup extends StatelessWidget {
  final String message;
  final String userName;

  const ChatMessageGroup({
    Key? key,
    required this.message,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Text(userName[0].toUpperCase()),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
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