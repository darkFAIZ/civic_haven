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
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  bool createAccount = false;
  bool codeSent = false;
  bool busy = false;
  String? verificationId;
  String? errorMessage;

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Future<void> sendCode() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => errorMessage = 'Enter a phone number with country code.');
      return;
    }
    if (DefaultFirebaseOptions.currentPlatform.apiKey == 'demo-api-key') {
      setState(() => errorMessage = 'Firebase is using placeholder credentials. Configure a Firebase project before sending OTP.');
      return;
    }
    setState(() {
      busy = true;
      errorMessage = null;
    });
    try {
      await AuthService.instance.auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) async {
          await _finishSignIn(credential, phone);
        },
        verificationFailed: (error) {
          if (mounted) {
            setState(() {
              busy = false;
              errorMessage = error.message ?? 'Could not send the verification code.';
            });
          }
        },
        codeSent: (id, _) {
          if (mounted) {
            setState(() {
              verificationId = id;
              codeSent = true;
              busy = false;
            });
          }
        },
        codeAutoRetrievalTimeout: (id) => verificationId = id,
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          busy = false;
          errorMessage = 'Firebase is not configured for this device yet.';
        });
      }
    }
  }

  Future<void> confirmCode() async {
    final id = verificationId;
    if (id == null || codeController.text.trim().length < 6) {
      setState(() => errorMessage = 'Enter the 6-digit code from Firebase.');
      return;
    }
    setState(() {
      busy = true;
      errorMessage = null;
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: id,
        smsCode: codeController.text.trim(),
      );
      await _finishSignIn(credential, phoneController.text.trim());
    } on FirebaseAuthException catch (error) {
      setState(() {
        busy = false;
        errorMessage = error.message ?? 'That verification code is not valid.';
      });
    }
  }

  Future<void> _finishSignIn(AuthCredential credential, String phone) async {
    final result = await AuthService.instance.auth.signInWithCredential(credential);
    final user = result.user;
    if (user == null) throw StateError('Firebase did not return a user.');

    final exists = await AuthService.instance.profileExists(user.uid);
    if (createAccount && exists) {
      await AuthService.instance.auth.signOut();
      throw StateError('An account already exists. Choose Log in instead.');
    }
    if (!createAccount && !exists) {
      await AuthService.instance.auth.signOut();
      throw StateError('No CivicHaven account exists for this number. Create an account first.');
    }
    if (createAccount) {
      await AuthService.instance.saveProfile(user: user, phoneNumber: phone);
    } else {
      await AuthService.instance.updateLastLogin(user.uid);
    }
    if (mounted) {
      setState(() => busy = false);
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
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration('Phone number', Icons.phone_outlined),
                  ),
                  if (codeSent) ...[
                    const SizedBox(height: 14),
                    TextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: const TextStyle(color: Colors.white),
                      decoration: _decoration('Firebase OTP code', Icons.lock_outline),
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: busy ? null : (codeSent ? confirmCode : sendCode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7EC7F7),
                        foregroundColor: const Color(0xFF0F1720),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(codeSent ? 'Verify and continue' : 'Send OTP code'),
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
                                codeSent = false;
                                verificationId = null;
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
                    'A Firebase SMS code is required. Existing accounts can log in; new accounts must be created first.',
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
