import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/bottom_screens/add_request_screen.dart';
import 'package:blood_token_app/screens/main_screens/main_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/profile_section_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/bottom_screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
        1. By wrapping each screen with a PageStorage widget and providing a unique PageStorageBucket,
        2. the state of each screen will be stored and maintained when navigating between them
        3. using the bottom navigation bar.
      */
      body: PageStorage(
        bucket: bucket,
        child: _buildScreen(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.black,
        selectedItemColor: AppUtils.redColor,
        showUnselectedLabels: true,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return MainScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const AddRequestScreen();
      case 3:
        return const ProfileSectionScreen();
      default:
        return MainScreen();
    }
  }
}
