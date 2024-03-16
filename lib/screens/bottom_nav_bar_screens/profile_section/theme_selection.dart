import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum to represent different theme options
enum ThemeModeOption { Light, Dark, System }

// ThemeSelectionScreen widget to allow users to choose app theme
class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

// State class for ThemeSelectionScreen widget
class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  // Variable to store the selected theme mode
  ThemeModeOption? _selectedTheme;

  // Initialize the state
  @override
  void initState() {
    // Load the selected theme from local storage
    _loadTheme();
    super.initState();
  }

  // Build method to construct the UI
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size size = MediaQuery.of(context).size;

    // Return the widget tree
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
            // Radio buttons for theme options
            RadioListTile<ThemeModeOption>(
              title: Text('Light Mode'),
              value: ThemeModeOption.Light,
              groupValue: _selectedTheme,
              onChanged: (value) {
                // Update theme when user selects Light Mode
                _setTheme(value!);
              },
            ),
            RadioListTile<ThemeModeOption>(
              title: Text('Dark Mode'),
              value: ThemeModeOption.Dark,
              groupValue: _selectedTheme,
              onChanged: (value) {
                // Update theme when user selects Dark Mode
                _setTheme(value!);
              },
            ),
            RadioListTile<ThemeModeOption>(
              title: Text('System Theme'),
              value: ThemeModeOption.System,
              groupValue: _selectedTheme,
              onChanged: (value) {
                // Update theme when user selects System Theme
                _setTheme(value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to set the selected theme
  void _setTheme(ThemeModeOption theme) async {
    // Access shared preferences for storing the theme
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Store the selected theme
    await prefs.setString('themeMode', theme.toString());

    // Apply the new theme immediately
    setState(() {
      _selectedTheme = theme;
    });

    // Debug print to verify theme change
    print('Theme set to: $theme');

    // **Here's the completed part**
    // 1. Inform the parent widget (MyApp) about the theme change (optional)
    // You can use a callback function or provider package for this.
    // For simplicity, we'll use a Navigator pop with arguments here.

    // Pass the selected theme back to the previous screen
    Navigator.pop(context, theme);

    // 2. Rebuild the theme in MyApp
    // This functionality should be implemented in MyApp's widget build method
    // based on the received theme from the ThemeSelectionScreen.
  }

  // Method to load the selected theme from local storage
  void _loadTheme() async {
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the saved theme mode from local storage
    String? theme = prefs.getString('themeMode');
    // Set the selected theme based on the retrieved value,
    // or set it to the default (system) if no value is found
    setState(() {
      _selectedTheme = theme != null
          ? ThemeModeOption.values
              .firstWhere((element) => element.toString() == theme)
          : ThemeModeOption.System;
    });
  }
}
