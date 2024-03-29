import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/bottom_screens/home_screen.dart';
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserLandingScreen extends StatelessWidget {
  final void Function(ThemeMode)? drawerChangeTheme;

  const UserLandingScreen({Key? key, this.drawerChangeTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: AppUtils.customProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error.toString()}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          // Added this line to get the user from snapshot
          final user = snapshot.data;
          if (user != null) {
            // Navigate to the home screen if user is logged in
            return const HomeScreen();
          } else {
            // Navigate to the login screen if user is logged out
            return LogInScreen(); // Changed LogInScreen() to LoginScreen()
          }
        }
      },
    );
  }
}
