import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption { Light, Dark, System }

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  ThemeModeOption? _selectedTheme;

  @override
  void initState() {
    _loadTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Selection'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            RadioListTile<ThemeModeOption>(
              title: Text('Light Mode'),
              value: ThemeModeOption.Light,
              groupValue: _selectedTheme,
              onChanged: (value) {
                _setTheme(value!);
              },
            ),
            RadioListTile<ThemeModeOption>(
              title: Text('Dark Mode'),
              value: ThemeModeOption.Dark,
              groupValue: _selectedTheme,
              onChanged: (value) {
                _setTheme(value!);
              },
            ),
            RadioListTile<ThemeModeOption>(
              title: Text('System Theme'),
              value: ThemeModeOption.System,
              groupValue: _selectedTheme,
              onChanged: (value) {
                _setTheme(value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setTheme(ThemeModeOption theme) async {
    setState(() {
      _selectedTheme = theme;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme.toString());

    // Manually trigger rebuild of the parent widget (MyApp) to apply the new theme
    Navigator.pop(context);
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
