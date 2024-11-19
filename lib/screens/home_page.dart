import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/widgets.dart';
import 'auth/authentication.dart';
import 'chat/chat_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventure'),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, _) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 8),
              AuthFunc(
                loggedIn: authProvider.isLoggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              const Divider(
                height: 8,
                thickness: 1,
                indent: 8,
                endIndent: 8,
                color: Colors.grey,
              ),
              if (authProvider.isLoggedIn) ...[
                const SizedBox(height: 16),
                const Header('Chat'),
                const Chat(),
              ] else ...[
                const Center(
                    child: Text('Please log in to view the map and chat')),
              ],
            ],
          );
        },
      ),
    );
  }
}
