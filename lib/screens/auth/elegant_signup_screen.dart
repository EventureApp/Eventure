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
  bool _isLoading = false;

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
        _errorMessage = 'Please fill out all fields.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user?.uid;
      if (userId == null) {
        setState(() {
          _errorMessage = 'Failed to create user.';
          _isLoading = false;
        });
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      AppUser appUser = AppUser(
        id: userId,
        username: '$firstName $lastName',
        firstName: firstName,
        lastName: lastName,
      );
      userProvider.addUser(appUser);
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
    Color secondaryColor = Colors.white,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        filled: true,
        labelStyle: TextStyle(color: secondaryColor),
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
    // Adjust these colors/fonts as needed
    final theme = Theme.of(context);

    var primaryColor = theme.colorScheme.primary;
    var backgroundColor = theme.colorScheme.background;
    var secondaryColor = theme.colorScheme.secondary;


    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, theme.colorScheme.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  // Top Hero/Image Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Create Account',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please fill out the form to create an account.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: secondaryColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // The form container
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                      color: backgroundColor,
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
                        _buildTextField(
                          _firstNameController,
                          'First Name',
                          prefixIcon: Icons.person_outline,
                          secondaryColor: secondaryColor,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _lastNameController,
                          'Last Name',
                          prefixIcon: Icons.person_outline,
                          secondaryColor: secondaryColor,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _emailController,
                          'E-Mail',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          secondaryColor: secondaryColor,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _passwordController,
                          'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          secondaryColor: secondaryColor,
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

                        // Sign up button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
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
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Sign up',
                                  style: TextStyle(
                                      fontSize: 16, color: secondaryColor),
                                ),
                        ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: (){
                                GoRouter.of(context).go('/sign-in');
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: secondaryColor),
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
