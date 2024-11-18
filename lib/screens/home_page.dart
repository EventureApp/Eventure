import 'package:eventure/screens/map/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
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
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 8),
              AuthFunc(
                loggedIn: appState.loggedIn,
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
              if (appState.loggedIn) ...[
                const SizedBox(height: 16),
                const SizedBox(
                  height: 400,
                  child: MapScreen(),
                ),
                const Header('Chat'),
                Chat(
                  addMessage: (message) => appState.addMessageToChat(message),
                  messages: appState.chatMessages,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
