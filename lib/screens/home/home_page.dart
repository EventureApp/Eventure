import 'package:eventure/providers/event_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../statics/custom_icons.dart';
import '../widgets/map.dart';
import 'package:eventure/screens/list/list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMapSelected = true;

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
                            fillColor: Colors.white),
                        onChanged: (value) {
                          eventProvider.setSearchString(value);
                        },
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    FirebaseAuth.instance.currentUser?.photoURL ??
                        'https://i.pravatar.cc/300',
                  ),
                ),
                onPressed: () {
                  context.push('/profile');
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
          color: Colors.white,
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
