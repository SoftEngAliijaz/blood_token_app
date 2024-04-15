import 'package:blood_token_app/constants/constants.dart'; // Importing constants file
import 'package:blood_token_app/screens/user_landing_screen/user_landing_screen.dart'; // Importing UserLandingScreen
import 'package:firebase_core/firebase_core.dart'; // Importing Firebase Core
import 'package:flutter/material.dart'; // Importing Flutter Material library

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp()); // Run the application
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(); // Create state for MyApp
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Token', // Set app title
      debugShowCheckedModeBanner: false, // Hide debug banner
      theme: ThemeData(
        cardColor: AppUtils.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppUtils.redColor, // Set app bar background color
          titleTextStyle: TextStyle(
              color: AppUtils.whiteColor,
              fontSize: 20.5), // Set app bar title text style
          iconTheme: IconThemeData(
              color: AppUtils.whiteColor), // Set app bar icon color
        ),
        primaryColor: AppUtils.redColor, // Set primary color
        hintColor: AppUtils.blueColor, // Set hint color
        scaffoldBackgroundColor:
            AppUtils.whiteColor, // Set scaffold background color
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                  color:
                      AppUtils.whiteColor)), // Set elevated button text color
              backgroundColor: MaterialStateProperty.all<Color>(
                  AppUtils.redColor)), // Set elevated button background color
        ),
      ),
      home: const UserLandingScreen(), // Set home screen to UserLandingScreen
    );
  }
}
