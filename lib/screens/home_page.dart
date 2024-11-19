import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/custom_icons_icons.dart';
import '../widgets/map.dart';

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
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
          MapWidget(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60, // Adjust the height to your liking
        child: BottomAppBar(
          color: Colors.white,
          elevation: 4,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    CustomIcons.filteroptions,
                    size: 24, // Consistent icon size
                  ),
                  onPressed: () {},
                ),
                ToggleButtons(
                  isSelected: [isMapSelected, !isMapSelected],
                  onPressed: (int index) {
                    setState(() {
                      isMapSelected = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(20.0),
                  children: [
                    Icon(CustomIcons.map, size: 24), // Consistent size
                    Icon(Icons.list, size: 24), // Consistent size
                  ],
                ),
                IconButton(
                  icon: Icon(
                    CustomIcons.plus,
                    size: 24, // Consistent icon size
                  ),
                  onPressed: () {
                    // Add action for plus button
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
