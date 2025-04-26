import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in_screen.dart'; // Import your SignInScreen
import 'sign_up_screen.dart'; // Import your SignUpScreen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is logged in by looking for the auth token
  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); // Check for saved token

    // Navigate to the appropriate screen based on the login status
    if (token != null) {
      // If the token exists, the user is logged in
      // You can navigate to the home screen or main app screen here
      // For now, we will just navigate to Sign-In to keep things simple
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      // If no token, navigate to the Sign-Up screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show loading indicator while checking
      ),
    );
  }
}
