import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  String? successMessage;

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
      setState(() {
        errorMessage = 'Enter a valid email address.';
        successMessage = null;
      });
      return;
    }
    if (password.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters.';
        successMessage = null;
      });
      return;
    }
    if (Firebase.apps.isEmpty) {
      setState(() {
        errorMessage = _firebaseUnavailableMessage;
        successMessage = null;
      });
      return;
    }
    setState(() {
      busy = true;
      errorMessage = null;
      successMessage = null;
    });
    try {
      final auth = AuthService.instance.auth;
      final result = createAccount
          ? await auth.createUserWithEmailAndPassword(email: email, password: password)
          : await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = result.user;
      if (user == null) throw StateError('Firebase did not return a user.');

      if (createAccount) {
        await AuthService.instance.saveProfile(user: user, email: email);
        await user.sendEmailVerification();
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

  Future<void> handleForgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        errorMessage = 'Enter your email address above to reset your password.';
        successMessage = null;
      });
      return;
    }

    if (Firebase.apps.isEmpty) {
      setState(() {
        errorMessage = _firebaseUnavailableMessage;
        successMessage = null;
      });
      return;
    }

    setState(() {
      busy = true;
      errorMessage = null;
      successMessage = null;
    });

    try {
      await AuthService.instance.sendPasswordReset(email);
      if (mounted) {
        setState(() {
          busy = false;
          successMessage = 'Password reset link sent to $email. Check your inbox!';
        });
      }
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
        return 'That email already has an account. Choose Log in.';
      case 'invalid-credential':
      case 'wrong-password':
        return 'Email or password is incorrect.';
      case 'user-not-found':
        return 'No account found. Choose Create an account first.';
      case 'weak-password':
        return 'Choose a stronger password with at least 6 characters.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment and try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      default:
        return 'Could not authenticate with Firebase ($code).';
    }
  }

  String get _firebaseUnavailableMessage {
    if (kIsWeb) {
      return 'Firebase is configured for Android only. Run this app on an Android device or add a web app with FlutterFire.';
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return 'Firebase is configured for Android only. Run this app on an Android device or emulator.';
    }
    return 'Firebase could not start. Check the Firebase configuration and try again.';
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
                    decoration: _decoration('Email address', Icons.email_outlined),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration('Password', Icons.lock_outline),
                  ),
                  if (!createAccount) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: busy ? null : handleForgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Color(0xFF7EC7F7), fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
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
                  if (successMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(successMessage!, style: const TextStyle(color: Color(0xFFB8F3C8))),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: busy
                          ? null
                          : () => setState(() {
                                createAccount = !createAccount;
                                errorMessage = null;
                                successMessage = null;
                              }),
                      child: Text(
                        createAccount ? 'Already have an account? Log in' : 'New here? Create an account',
                        style: const TextStyle(color: Color(0xFF7EC7F7)),
                      ),
                    ),
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