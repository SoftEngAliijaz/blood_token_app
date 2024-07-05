import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/rating_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
        cardColor: AppUtils.whiteColor,
        appBarTheme: const AppBarTheme(
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
                  const TextStyle(color: AppUtils.whiteColor)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppUtils.redColor)),
        ),
      ),
      home: UserRatingUIScreen(),
    );
  }
}
