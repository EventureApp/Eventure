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
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final userId = credential.user?.uid;

      if (userId == null) {
        setState(() {
          _errorMessage =
              'Failed to sign in. Please check your credentials and try again.';
          _isLoading = false;
        });
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.getCurrentUser(userId);

      setState(() {
        _isLoading = false;
      });

      GoRouter.of(context).go('/');
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool obscureText = false,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black54),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var primaryColor = theme.primaryColor;
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Hintergrund-Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, const Color(0xFFF5F5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header / Hero-Bereich
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Optional: Logo oder Bild hinzufügen
                        // Beispiel:
                        // Image.asset(
                        //   'assets/images/logo.png',
                        //   height: 100,
                        // ),
                        // const SizedBox(height: 20),
                        Text(
                          'Welcome to Eventure!',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Formular Container
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Eingabefelder
                        _buildTextField(
                          _emailController,
                          'E-Mail',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          _passwordController,
                          'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
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
                          onPressed: _isLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
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
                              'Forgot password?',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Registrieren-Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                context.push('/sign-up');
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
