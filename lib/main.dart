import 'package:eventure/provider/eventure_provider.dart';
import 'package:eventure/screens/event_details.dart';
import 'package:eventure/screens/event_list.dart';
import 'package:eventure/screens/login_screen.dart';
import 'package:eventure/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => EventureProvider(),
          child:const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventure',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(title: "Login screen title"),
        '/register' : (context) => const RegistrationScreen(title: "Registration screen title"),
        '/event_list' : (context) => const EventList(title: "Event list title"),
        '/event_details' : (context) => const EventDetails(title: "Event details title")
      },
    );
  }
}