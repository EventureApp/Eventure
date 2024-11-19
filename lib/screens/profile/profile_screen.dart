import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, _) {
        return ProfileScreen(
          key: ValueKey(authProvider.isEmailVerified),
          providers: const [],
          actions: [
            SignedOutAction(
              (context) async {
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                context.go('/'); // Navigate to home page after sign-out
              },
            ),
          ],
          children: [
            Visibility(
              visible: !authProvider.isEmailVerified,
              child: OutlinedButton(
                child: const Text('Recheck Verification State'),
                onPressed: () {
                  authProvider.refreshUser();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
