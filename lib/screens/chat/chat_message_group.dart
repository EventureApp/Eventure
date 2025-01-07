import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class ChatMessageGroup extends StatefulWidget {
  final String message;
  final Future<AppUser> userFuture;

  const ChatMessageGroup({
    Key? key,
    required this.message,
    required this.userFuture,
  }) : super(key: key);

  @override
  _ChatMessageGroupState createState() => _ChatMessageGroupState();
}

class _ChatMessageGroupState extends State<ChatMessageGroup> {
  late Future<AppUser> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = widget.userFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              const CircleAvatar(
                child: CircularProgressIndicator(),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              const CircleAvatar(child: Icon(Icons.error)),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          AppUser user = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundImage: user.profilePicture != null
                    ? MemoryImage(user.profilePicture!)
                    : null,
                child: user.profilePicture == null
                    ? Text(user.username[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.message,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
