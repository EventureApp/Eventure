import 'package:eventure/models/user.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ElegantSignUpScreen extends StatefulWidget {
  const ElegantSignUpScreen({Key? key}) : super(key: key);

  @override
  State<ElegantSignUpScreen> createState() => _ElegantSignUpScreenState();
}

class _ElegantSignUpScreenState extends State<ElegantSignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _errorMessage = '';

  Future<void> _signUp() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      setState(() {
        _errorMessage = 'Bitte fülle alle Felder aus.';
      });
      return;
    }

    try {
      // Erstelle einen neuen User in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // User-ID auslesen
      final userId = credential.user?.uid;
      final userEmail = credential.user?.email;

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (userId == null) {
        setState(() {
          _errorMessage = 'Es gab ein Problem bei der Registrierung.';
        });
        return;
      }
      AppUser appUser = AppUser(
          id: userId,
          username: firstName + ' ' + lastName,
          firstName: firstName,
          lastName: lastName);
      userProvider.addUser(appUser);
      userProvider.getCurrentUser(userId);

      // Navigation zur Startseite
      GoRouter.of(context).go('/');
    } catch (e) {
      setState(() {
        _errorMessage = 'Registrierung fehlgeschlagen: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const primaryColor = Color(0xFF1976D2);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDCE9F5), Color(0xFFF5F5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_add,
                          size: 48,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Konto erstellen',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gib deine Daten ein, um dich zu registrieren',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Name
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // E-Mail
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Passwort
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),

                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Registrieren',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Bereits ein Konto?'),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).go('/sign-in');
                        },
                        child: Text(
                          'Anmelden',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
