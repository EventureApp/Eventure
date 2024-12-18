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

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  // Hilfsfunktion zur Überprüfung, ob ein String nicht null und nicht leer ist
  bool _isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  // Hilfsfunktion zur Überprüfung, ob eine Liste nicht null und nicht leer ist
  bool _hasItems(List? list) {
    return list != null &&
        list.isNotEmpty &&
        list.any(
            (item) => item != null && item.trim().isNotEmpty && item != '');
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Profil bearbeiten',
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
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profilkopf
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          currentUser?.photoURL ?? 'https://i.pravatar.cc/300',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${user.firstName ?? ''} ${user.lastName ?? ''}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Beschreibung (nur anzeigen, wenn vorhanden)
                if (_isNotEmpty(user.description))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Beschreibung',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user.description!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_isNotEmpty(user.description)) const SizedBox(height: 10),

                // Bildung (nur anzeigen, wenn mindestens Universität oder Studiengang vorhanden ist)
                if (_isNotEmpty(user.uni) || _isNotEmpty(user.studyCourse))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.school,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_isNotEmpty(user.uni))
                                    Text(
                                      user.uni!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (_isNotEmpty(user.uni) &&
                                      _isNotEmpty(user.studyCourse))
                                    const SizedBox(height: 5),
                                  if (_isNotEmpty(user.studyCourse))
                                    Text(
                                      user.studyCourse!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_isNotEmpty(user.uni) || _isNotEmpty(user.studyCourse))
                  const SizedBox(height: 10),

                // Soziale Medien (bereits bedingt angezeigt)
                if (_hasItems(user.socialMediaLinks))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Soziale Medien',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...user.socialMediaLinks!.map((link) {
                              if (_isNotEmpty(link)) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.link,
                                          color: Colors.blue),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          link!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_hasItems(user.socialMediaLinks))
                  const SizedBox(height: 10),

                // Freunde (bereits bedingt angezeigt)
                if (_hasItems(user.friends))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Freunde',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: user.friends!
                                  .map((friend) => Chip(
                                        label: Text(friend!),
                                        avatar:
                                            const Icon(Icons.person, size: 20),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_hasItems(user.friends)) const SizedBox(height: 20),

                // Logout Button (immer anzeigen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Abmelden',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      await Provider.of<AuthenticationProvider>(context,
                              listen: false)
                          .logout();
                      context.go("/sign-in");
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
