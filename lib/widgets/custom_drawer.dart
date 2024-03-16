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
            decoration: BoxDecoration(color: Colors.red),
            child: Container(
              child: CircleAvatar(backgroundColor: Colors.blue),
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
                  widget.onThemeChanged!(value);
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
                  widget.onThemeChanged!(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
