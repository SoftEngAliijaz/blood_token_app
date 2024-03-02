import 'package:blood_token_app/screens/bottom_nav_bar_screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Token',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardColor: Colors.white,
        textTheme: GoogleFonts.firaSansTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
              // statusBarColor: Colors.black,
              // systemNavigationBarColor: Colors.black,
              // systemStatusBarContrastEnforced: true,
              // systemNavigationBarDividerColor: Colors.red,
              // statusBarIconBrightness: Brightness.light,
              // systemNavigationBarIconBrightness: Brightness.light,
              ),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
