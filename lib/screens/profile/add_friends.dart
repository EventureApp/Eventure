import 'package:eventure/providers/user_provider.dart';
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
        appBar: AppBar(
          title: const Text("Search users, add friends"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white),
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
                padding:const EdgeInsets.all(10),
                itemCount: usersStartingWith.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                        "${usersStartingWith[index].firstName} ${usersStartingWith[index].lastName}"),
                    subtitle: Text("${usersStartingWith[index].uni}"),
                    trailing: StyledButton(
                        onPressed: () {},
                        child: const Text("Send friend request")),
                  );
                },
              ));
            }),
          ],
        ));
  }
}
