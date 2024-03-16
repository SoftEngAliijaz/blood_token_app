import 'package:blood_token_app/screens/bottom_nav_bar_screens/bottom_screens/home_screen.dart';
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserLandingScreen extends StatelessWidget {
  const UserLandingScreen(
      {Key? key, required void Function(ThemeMode mode) drawerChangeTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildWaitingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error.toString());
        } else {
          return _buildUserScreen(snapshot.data);
        }
      },
    );
  }

  Widget _buildWaitingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Center(
      child: Text(
        'Error: $errorMessage',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildUserScreen(User? user) {
    if (user != null) {
      // Navigate to the home screen if user is logged in
      return const HomeScreen();
    } else {
      // Navigate to the login screen if user is logged out
      return const LogInScreen();
    }
  }
}
