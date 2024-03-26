import 'package:blood_token_app/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final void Function(ThemeMode)? onThemeChanged;

  const CustomDrawer({Key? key, this.onThemeChanged}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  ThemeMode _selectedTheme = ThemeMode.light; // Default to light mode

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppUtils.redColor),
            child: Container(
              child: CircleAvatar(backgroundColor: AppUtils.blueColor),
            ),
          ),
          ListTile(
            title: Text('Light Mode'),
            leading: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: _selectedTheme,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _selectedTheme = value!;
                  if (widget.onThemeChanged != null) {
                    // Check if onThemeChanged is not null
                    widget.onThemeChanged!(value); // Call theme change callback
                  }
                });
              },
            ),
          ),
          ListTile(
            title: Text('Dark Mode'),
            leading: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: _selectedTheme,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _selectedTheme = value!;
                  if (widget.onThemeChanged != null) {
                    // Check if onThemeChanged is not null
                    widget.onThemeChanged!(value); // Call theme change callback
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
