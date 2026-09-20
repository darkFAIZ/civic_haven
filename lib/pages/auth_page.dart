import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool createAccount = false;
  bool busy = false;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submitAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || !email.contains('@')) {
      setState(() => errorMessage = 'Enter a valid Gmail address.');
      return;
    }
    if (password.length < 6) {
      setState(() => errorMessage = 'Password must be at least 6 characters.');
      return;
    }
    if (DefaultFirebaseOptions.currentPlatform.apiKey == 'demo-api-key') {
      setState(() => errorMessage = 'Firebase is using placeholder credentials. Configure a Firebase project first.');
      return;
    }
    setState(() {
      busy = true;
      errorMessage = null;
    });
    try {
      final auth = AuthService.instance.auth;
      final result = createAccount
          ? await auth.createUserWithEmailAndPassword(email: email, password: password)
          : await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = result.user;
      if (user == null) throw StateError('Firebase did not return a user.');

      if (createAccount) {
        await user.sendEmailVerification();
        await AuthService.instance.saveProfile(user: user, email: email);
      } else {
        await AuthService.instance.updateLastLogin(user.uid);
      }
      if (mounted) setState(() => busy = false);
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(() {
          busy = false;
          errorMessage = _authError(error.code);
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          busy = false;
          errorMessage = error.toString();
        });
      }
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'That Gmail already has an account. Choose Log in.';
      case 'invalid-credential':
      case 'wrong-password':
        return 'Gmail or password is incorrect.';
      case 'user-not-found':
        return 'No account found. Choose Create an account first.';
      case 'weak-password':
        return 'Choose a stronger password with at least 6 characters.';
      case 'invalid-email':
        return 'Enter a valid Gmail address.';
      default:
        return 'Could not authenticate with Firebase ($code).';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_rounded, color: Color(0xFF7EC7F7), size: 54),
                  const SizedBox(height: 24),
                  const Text(
                    'CivicHaven',
                    style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    createAccount ? 'Create a protected account' : 'Sign in to your account',
                    style: const TextStyle(color: Color(0xFF9FB7C7), fontSize: 17),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration('Gmail address', Icons.email_outlined),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration('Password', Icons.lock_outline),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: busy ? null : submitAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7EC7F7),
                        foregroundColor: const Color(0xFF0F1720),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(createAccount ? 'Create account' : 'Log in'),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(errorMessage!, style: const TextStyle(color: Color(0xFFFF9B9B))),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: busy
                          ? null
                          : () => setState(() {
                                createAccount = !createAccount;
                                errorMessage = null;
                              }),
                      child: Text(
                        createAccount ? 'Already have an account? Log in' : 'New here? Create an account',
                        style: const TextStyle(color: Color(0xFF7EC7F7)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Use a Gmail address and password. New accounts receive a Firebase verification email.',
                    style: TextStyle(color: Color(0xFF708999), height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _decoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFF9FB7C7)),
    prefixIcon: Icon(icon, color: const Color(0xFF7EC7F7)),
    filled: true,
    fillColor: const Color(0xFF1F2B36),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );
}
