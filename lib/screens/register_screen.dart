import 'package:eventure/provider/eventure_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.title});

  final String title;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

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
                child:const Text("Register"),
                onPressed:(){
                  context.read<EventureProvider>().username = _usernameInput.text;
                  Navigator.pop(context);
                }
            )
          ],
        ),
      ),
    );
  }
}
