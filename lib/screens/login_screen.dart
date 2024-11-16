import 'package:eventure/provider/eventure_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _usernameInput = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter username',
            ),
            TextField(
              controller:_usernameInput
            ),
            TextButton(
              child:const Text("Login"),
              onPressed:(){
                context.read<EventureProvider>().username = _usernameInput.text;
                Navigator.pushReplacementNamed(context,"/event_list");
              }
            ),
            TextButton(
                child:const Text("To registration"),
                onPressed:(){
                  context.read<EventureProvider>().username = _usernameInput.text;
                  Navigator.pushNamed(context,"/register");
                }
            )
          ],
        ),
      ),
    );
  }
}
