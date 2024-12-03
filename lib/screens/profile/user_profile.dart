import 'package:eventure/providers/auth_provider.dart';
import 'package:eventure/screens/profile/user_profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventure/providers/user_provider.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFFB7CBDD),
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
                      user.firstName ?? 'my-user',
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
                    Text('Username: ${user.username ?? ''}'),
                    Text('University: ${user.uni ?? ''}'),
                    Text('Course: ${user.studyCourse ?? ''}'),
                    Text(
                        'Name: ${user.firstName ?? ''} ${user.lastName ?? ''}'),
                    Text('Description: ${user.description ?? ''}'),
                    if (user.socialMediaLinks != null &&
                        user.socialMediaLinks!.isNotEmpty)
                      Text(
                          'Social Media: ${user.socialMediaLinks!.join(', ')}'),
                    if (user.friends != null && user.friends!.isNotEmpty)
                      Text('Friends: ${user.friends!.join(', ')}'),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Consumer<AuthenticationProvider>(
                  builder: (context, authProvider, _) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: () async {
                          await authProvider.logout();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
