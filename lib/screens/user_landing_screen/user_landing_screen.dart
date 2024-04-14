import 'package:blood_token_app/constants/constants.dart'; // Importing constants file
import 'package:blood_token_app/screens/bottom_nav_bar_screens/bottom_screens/home_screen.dart'; // Importing home screen
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importing FirebaseAuth
import 'package:flutter/material.dart'; // Importing Flutter Material library

class UserLandingScreen extends StatelessWidget {
  final void Function(ThemeMode)?
      drawerChangeTheme; // Function to change theme mode

  const UserLandingScreen({Key? key, this.drawerChangeTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Listening to authentication state changes
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: AppUtils
                  .customProgressIndicator()); // Displaying custom progress indicator while waiting for authentication state
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error.toString()}', // Displaying error message if there's an error
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          // Extracting user from snapshot
          final user = snapshot.data;
          if (user != null) {
            // Navigate to home screen if user is logged in
            return const HomeScreen();
          } else {
            // Navigate to login screen if user is logged out
            return LogInScreen(); // Corrected the class name to LoginScreen
          }
        }
      },
    );
  }
}
