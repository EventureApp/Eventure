import 'package:eventure/providers/auth_provider.dart';
import 'package:eventure/screens/auth/authentication.dart';
import 'package:eventure/screens/profile/add_friends.dart';
import 'package:eventure/screens/profile/user_profile_edit.dart';
import 'package:eventure/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:eventure/providers/user_provider.dart';
import '../../models/user.dart';

class ProfileDetailScreen extends StatelessWidget {
  final AppUser? user; // Optional user

  const ProfileDetailScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    // Fallback to the current authenticated user if no user is passed
    final currentUser = FirebaseAuth.instance.currentUser;
    final displayedUser = user ?? context.read<UserProvider>().user;

    // Determine if the current user is being viewed
    final isCurrentUser = user == null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: displayedUser != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    currentUser?.photoURL ?? 'https://i.pravatar.cc/300',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${displayedUser.firstName} ${displayedUser.lastName}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(displayedUser.description ?? ''),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.school),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayedUser.uni ?? ''),
                        Text(displayedUser.studyCourse ?? ''),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}


