import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/screens/user_landing_screen/user_landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Token',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppUtils.redColor,
          titleTextStyle: TextStyle(color: AppUtils.whiteColor, fontSize: 20.5),
          iconTheme: IconThemeData(color: AppUtils.whiteColor),
        ),
        primaryColor: AppUtils.redColor,
        hintColor: AppUtils.blueColor,
        scaffoldBackgroundColor: AppUtils.whiteColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(color: AppUtils.whiteColor)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppUtils.redColor)),
        ),
      ),
      home: UserLandingScreen(),
    );
  }
}
