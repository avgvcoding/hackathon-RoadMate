import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../home_screen.dart';
import 'google_registration_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  // Sign in with Email & Password
  Future<void> _signInWithEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    final result = await _authService.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Sign in failed. Please check your credentials.';
      });
    }
  }

  // Sign in with Google and check for extra profile details in Firestore.
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    final result = await _authService.signInWithGoogle();
    setState(() {
      _isLoading = false;
    });
    if (result != null) {
      // Check if the user's extra profile details exist in Firestore.
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .get();
      if (!doc.exists) {
        // Navigate to the GoogleRegistrationScreen for first-time Google users.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GoogleRegistrationScreen(
              prefilledName: result.user!.displayName,
              prefilledEmail: result.user!.email,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Google sign in failed. Please try again.';
      });
    }
  }

  // Sign in as Guest (anonymous)
  Future<void> _signInAsGuest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    final result = await _authService.signInAnonymously();
    setState(() {
      _isLoading = false;
    });
    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Guest sign in failed. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 113, 123, 255),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color.fromARGB(255, 189, 226, 255)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Branding: App icon on the left and "RoadMate" text on the right
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png', // App logo asset path
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'RoadMate',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 42, 22, 255),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                if (_errorMessage.isNotEmpty) ...[
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                ],
                // Email field
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Color.fromARGB(240, 255, 255, 255),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Color.fromARGB(239, 255, 255, 255),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signInWithEmail,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login with Email'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: Image.asset(
                    'assets/icons/google.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 191, 218, 255),
                  ),
                ),
                const SizedBox(height: 10),
                // Guest sign in button
                ElevatedButton(
                  onPressed: _isLoading ? null : _signInAsGuest,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Continue as Guest'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text('New user? Register here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
