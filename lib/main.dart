import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/screens/user_landing_screen/user_landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize with a default value
  late ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeModeIndex =
        prefs.getInt('themeMode') ?? ThemeModeOption.Light.index;
    setState(() {
      _themeMode = ThemeModeOption.values[themeModeIndex].toThemeMode();
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    setState(() {
      _themeMode = mode;
    });
  }

  void _changeTheme(ThemeMode mode) {
    _saveThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Token',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.5),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primaryColor: Colors.red,
        hintColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        hintColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: UserLandingScreen(),
    );
  }
}
