import 'package:blood_token_app/screens/user_landing_screen/user_landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

enum ThemeModeOption { Light, Dark, System }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeModeOption? _selectedTheme;

  @override
  void initState() {
    _loadTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Token',
      debugShowCheckedModeBanner: false,
      theme: _selectedTheme == ThemeModeOption.Dark
          ? ThemeData.dark().copyWith(
              textTheme: GoogleFonts.firaSansTextTheme(
                Theme.of(context).textTheme.copyWith(
                      // Ensure consistent text color in dark theme
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
            )
          : ThemeData.light().copyWith(
              textTheme: GoogleFonts.firaSansTextTheme(
                Theme.of(context).textTheme.copyWith(
                      // Ensure consistent text color in light theme
                      bodyText1: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .apply(color: Colors.black),
                      bodyText2: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .apply(color: Colors.black),
                    ),
              ),
            ),
      home: UserLandingScreen(),
    );
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    setState(() {
      _selectedTheme = theme != null
          ? ThemeModeOption.values
              .firstWhere((element) => element.toString() == theme)
          : ThemeModeOption.System;
    });
  }
}
