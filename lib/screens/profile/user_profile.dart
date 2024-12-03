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
      body: Column(
        children: [
          Container(
            color: const Color(0xFFB7CBDD),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    currentUser?.photoURL ?? 'https://i.pravatar.cc/300',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentUser?.displayName ?? 'my-user',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return ListView.builder(
                  itemCount: userProvider.users.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.users[index];
                    return ListTile(
                      title: Text(user.username ?? ''),
                      subtitle: Text(user.uni ?? ''),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
