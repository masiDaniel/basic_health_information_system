import 'package:flutter/material.dart';
import 'package:health_frontend/screens/programs_screen.dart';
import 'package:health_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      Map<String, dynamic> response = await AuthService().signIn(
        username,
        password,
      );
      String token = response['token'];

      // Save the token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', token);

      // Navigate to the home screen or wherever after login
      print("Logged in successfully with token: $token");

      // Example: Navigate to Home screen or the main app screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProgramsScreen()),
      );
    } catch (e) {
      // Handle login failure
      print("Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed! Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signIn, child: Text('Sign In')),
          ],
        ),
      ),
    );
  }
}
