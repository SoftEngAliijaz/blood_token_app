import 'package:blood_token_app/screens/user_landing_screen/user_landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Main function to start the Flutter app
void main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  // Run the app
  runApp(MyApp());
}

// Enum to define different theme modes
enum ThemeModeOption { Light, Dark, System }

// MyApp class, the root of the application
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// State class for MyApp widget
class _MyAppState extends State<MyApp> {
  // Variable to store the selected theme mode
  ThemeModeOption? _selectedTheme;

  // Initialize the state
  @override
  void initState() {
    // Load the selected theme mode from local storage
    _loadTheme();
    super.initState();
  }

  // Build method to construct the UI
  @override
  Widget build(BuildContext context) {
    // Return the MaterialApp widget with specified configurations
    return MaterialApp(
      // App title
      title: 'Blood Token',
      // Disable debug banner
      debugShowCheckedModeBanner: false,
      // Set app theme based on selected theme mode
      theme: _getThemeData(),
      // Initial route of the app
      home: UserLandingScreen(),
    );
  }

  // Method to get ThemeData based on selected theme mode
  ThemeData _getThemeData() {
    switch (_selectedTheme) {
      case ThemeModeOption.Light:
        // Return light theme
        return ThemeData.light();
      case ThemeModeOption.Dark:
        // Return dark theme with custom text theme
        return ThemeData.dark().copyWith(
          textTheme: GoogleFonts.firaSansTextTheme(
            Theme.of(context).textTheme.copyWith(
                  // Customize text color for dark theme
                  bodyText1: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .apply(color: Colors.white),
                  bodyText2: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .apply(color: Colors.white),
                ),
          ),
        );
      case ThemeModeOption.System:
      default:
        // Return default theme (system theme)
        return ThemeData.light();
    }
  }

  // Method to load the selected theme mode from local storage
  void _loadTheme() async {
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the saved theme mode from local storage
    String? theme = prefs.getString('themeMode');
    setState(() {
      // Set the selected theme mode based on the retrieved value,
      // or set it to the default (system) if no value is found
      _selectedTheme = theme != null
          ? ThemeModeOption.values
              .firstWhere((element) => element.toString() == theme)
          : ThemeModeOption.System;
    });
  }
}
