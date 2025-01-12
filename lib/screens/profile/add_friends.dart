import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/screens/profile/user_profile.dart';
import 'package:eventure/widgets/inputs/custom_input_line.dart';
import 'package:eventure/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});
  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().fetchUsersStartingWith();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text("User list"),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface),
                onChanged: (value) {
                  context.read<UserProvider>().queryStartsWith = value;
                  context.read<UserProvider>().fetchUsersStartingWith();
                },
              ),
            ),
            Consumer<UserProvider>(builder: (context, userProvider, child) {
              userProvider.fetchFriends();
              List<AppUser> usersStartingWith = userProvider.usersStartingWith;
              return Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: usersStartingWith.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(50),
                          left: Radius.circular(50),
                        ),
                      ),
                      title: Text(
                        "${usersStartingWith[index].firstName} ${usersStartingWith[index].lastName}",
                      ),
                      subtitle: Text("${usersStartingWith[index].uni}"),
                      trailing: InkWell(
                        onTap: () {}, // Your action here
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // White border
                              width: 2, // Border width
                            ),
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                            color: Colors.transparent, // Transparent background
                          ),
                          child: const Text(
                            "Send friend request",
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileDetailScreen(
                              user: usersStartingWith[index], // Pass user or omit to use the current user
                            ),
                          ),
                        );
                      },
                    )


                  );
                },
              ));
            }),
          ],
        ));
  }
}
