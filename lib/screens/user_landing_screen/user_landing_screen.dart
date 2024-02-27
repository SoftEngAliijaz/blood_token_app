import 'package:blood_token_app/screens/main_screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/screens/credientals/login_screen.dart';

class UserLandingScreen extends StatelessWidget {
  const UserLandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(child: AppUtils.customProgressIndicator());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(
              'Waiting for Connection...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          // Display an error message on the UI
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          //if user is logged in then will returned to homescreen
          return const HomeScreen();
        } else {
          //if user is logged out then will returned to loginscreen
          return const LogInScreen();
        }
      },
    );
  }
}
