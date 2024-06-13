import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/crud/my_blood_requests.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/blood_quotes_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/blood_tips_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/rate_app_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/share_app_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/user_profile_screen/user_profile_screen.dart';
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSectionScreen extends StatefulWidget {
  const ProfileSectionScreen({super.key});

  @override
  _ProfileSectionScreenState createState() => _ProfileSectionScreenState();
}

class _ProfileSectionScreenState extends State<ProfileSectionScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Section'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(
                              "assets/images/blood_token_logo_01.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _tileCard(
                Icons.person_outline,
                'My Profile',
                () {
                  navigateTo(context, UserProfileScreen());
                },
              ),
              _tileCard(Icons.request_page_outlined, 'My Requests', () {
                navigateTo(context, const MyBloodRequestsScreen());
              }),
              _tileCard(Icons.tips_and_updates_outlined, 'Blood Tips', () {
                navigateTo(context, const BloodTipsScreen());
              }),
              _tileCard(Icons.quora_outlined, 'Blood Quotes', () {
                navigateTo(context, const BloodQuotesScreen());
              }),
              _tileCard(Icons.share_outlined, 'Share App', () {
                navigateTo(context, const ShareAppScreen());
              }),
              _tileCard(Icons.rate_review_outlined, 'Rate Our App', () {
                navigateTo(context, const RateAppScreen());
              }),
              _tileCard(Icons.logout_outlined, 'SignOut', () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return const LogInScreen();
                }));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tileCard(
    IconData leadingIcon,
    String title,
    void Function()? onTap,
  ) {
    return ListTile(
        leading: Icon(leadingIcon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_outlined),
        onTap: onTap);
  }

  navigateTo(BuildContext context, Widget nextScreen) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return nextScreen;
    }));
  }
}
