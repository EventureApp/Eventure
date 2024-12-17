import 'package:eventure/models/user.dart';
import 'package:eventure/providers/event_provider.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../statics/custom_icons.dart';
import 'package:eventure/screens/list/list_screen.dart';
import 'package:eventure/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMapSelected = true;

  void _optionsDialog(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.profilePicture as String? ??
                        'https://i.pravatar.cc/300',
                  ),
                ),
                title: Text(
                  "${user.firstName ?? 'User'} ${user.lastName ?? 'Name'}",
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('User'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/userList');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/settings');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            children: [
              Expanded(
                child: Consumer<EventProvider>(
                  builder: (context, eventProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.primary),
                        onChanged: (value) {
                          eventProvider.setSearchString(value);
                        },
                      ),
                    );
                  },
                ),
              ),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;
                  return IconButton(
                    icon: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        user.profilePicture as String? ??
                            'https://i.pravatar.cc/300',
                      ),
                    ),
                    onPressed: () {
                      _optionsDialog(context, user);
                    },
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          isMapSelected
              ? const MapWidget() // Karte anzeigen
              : const ListScreen(), // Liste anzeigen
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: BottomAppBar(
          color: Theme.of(context).colorScheme.primary,
          elevation: 4,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    CustomIcons.filteroptions,
                    size: 24,
                  ),
                  onPressed: () {
                    context.push('/addFilter');
                  },
                ),
                ToggleButtons(
                  isSelected: [isMapSelected, !isMapSelected],
                  onPressed: (int index) {
                    setState(() {
                      isMapSelected = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).colorScheme.secondary, // Set the color of the icons
                  selectedColor:
                    Theme.of(context).colorScheme.secondary, // Set the color of the selected icon
                  fillColor: Theme.of(context)
                      .primaryColor, // Set the fill color when selected
                  splashColor: Colors.transparent,
                  children: const [
                    Icon(CustomIcons.map, size: 24),
                    Icon(Icons.list, size: 24),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    CustomIcons.plus,
                    size: 24,
                  ),
                  onPressed: () {
                    context.push('/addEvent');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
