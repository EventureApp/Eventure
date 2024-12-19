import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class ChatMessageGroup extends StatefulWidget {
  final String message;
  final Future<AppUser> userFuture;  // Ändere hier den Typ zu Future<AppUser>

  const ChatMessageGroup({
    Key? key,
    required this.message,
    required this.userFuture,  // Erwarte ein Future<AppUser>
  }) : super(key: key);

  @override
  _ChatMessageGroupState createState() => _ChatMessageGroupState();
}

class _ChatMessageGroupState extends State<ChatMessageGroup> {
  late Future<AppUser> userFuture;

  @override
  void initState() {
    super.initState();
    // initialisiere den userFuture hier, falls nötig
    userFuture = widget.userFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: userFuture,  // Das Future, das den AppUser lädt
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Wenn das Future noch läuft, zeige den Ladeindikator an
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,  // Benutzer nach links ausrichten
            children: [
              const SizedBox(width: 8),
              const CircleAvatar(
                child: CircularProgressIndicator(),  // Ladeindikator
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          // Fehlerfall, falls das Future fehlschlägt
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,  // Benutzer nach links ausrichten
            children: [
              const SizedBox(width: 8),
              const CircleAvatar(child: Icon(Icons.error)),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          // Wenn das Future erfolgreich abgeschlossen ist, nutze die Daten
          AppUser user = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,  // Benutzer nach links ausrichten
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
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color:Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Falls keine Daten vorhanden sind (shouldn't happen here)
          return const SizedBox();
        }
      },
    );
  }
}