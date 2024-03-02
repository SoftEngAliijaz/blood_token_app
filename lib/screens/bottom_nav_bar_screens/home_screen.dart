import 'package:blood_token_app/screens/bottom_nav_bar_screens/add_request_screen.dart';
import 'package:blood_token_app/screens/main_screens/main_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/profile_section_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///body
      body: Center(child: _buildScreen()),

      ///bottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        ///index
        currentIndex: _selectedIndex,

        ///onTap
        onTap: _onItemTapped,

        ///conditions
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red,
        showUnselectedLabels: true,
        backgroundColor: Colors.black,

        type: BottomNavigationBarType.shifting,

        ///items
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add Request',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  ///_onItemTapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///_buildScreen
  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return const MainScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const AddRequestScreen();
      case 3:
        return const ProfileSectionScreen();
      default:
        return const MainScreen();
    }
  }
}
