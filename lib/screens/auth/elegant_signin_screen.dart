import 'package:eventure/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ElegantSignInScreen extends StatefulWidget {
  const ElegantSignInScreen({Key? key}) : super(key: key);

  @override
  State<ElegantSignInScreen> createState() => _ElegantSignInScreenState();
}

class _ElegantSignInScreenState extends State<ElegantSignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _errorMessage = '';

  Future<void> _signIn() async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // User-ID auslesen
      final userId = credential.user?.uid;

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (userId == null) {
        setState(() {
          _errorMessage = 'Es gab ein Problem bei der Registrierung.';
        });
        return;
      }

      userProvider.getCurrentUser(userId);
      GoRouter.of(context).go('/');
    } catch (e) {
      setState(() {
        _errorMessage = 'Anmeldung fehlgeschlagen: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Primär- und Sekundärfarben für ein klares, professionelles Branding
    const primaryColor = Color(0xFF1976D2); // Ein frisches Blau
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      // Schöner Farbverlauf im Hintergrund für mehr Tiefe
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
                  // Header: Logo oder Icon
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Willkommen zurück!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Melde dich an, um fortzufahren',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Eingabefelder
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

                  // Anmeldebutton
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Anmelden',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Passwort vergessen
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Hier die Logik für "Passwort vergessen" einbauen
                      },
                      child: const Text(
                        'Passwort vergessen?',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Registrieren-Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Noch kein Konto?'),
                      TextButton(
                        onPressed: () {
                          context.push('/sign-up');
                        },
                        child: Text(
                          'Registrieren',
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
