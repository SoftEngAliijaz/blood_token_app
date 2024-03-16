import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/my_blood_requests.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/theme_selection.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/blood_quotes_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/blood_slogan_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/blood_tips_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/rate_app_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/profile_section/ui_screens/share_app_screen.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/user_profile_screen/user_profile_screen.dart';
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSectionScreen extends StatelessWidget {
  const ProfileSectionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Section'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///logo
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
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

              ///tiles
              _tileCard(
                Icons.person_outline,
                'My Profile',
                () {
                  navigateTo(context, UserProfileScreen());
                },
              ),

              _tileCard(Icons.request_page_outlined, 'My Requests', () {
                navigateTo(context, MyBloodRequestsScreen());
              }),

              _tileCard(Icons.tips_and_updates_outlined, 'Blood Tips', () {
                navigateTo(context, BloodTipsScreen());
              }),
              _tileCard(Icons.quora_outlined, 'Blood Quotes', () {
                navigateTo(context, BloodQuotesScreen());
              }),
              _tileCard(Icons.speaker_outlined, 'Slogans', () {
                navigateTo(context, BloodSloganScreen());
              }),
              _tileCard(Icons.share_outlined, 'Share App', () {
                navigateTo(context, ShareAppScreen());
              }),

              _tileCard(Icons.rate_review_outlined, 'Rate Our App', () {
                navigateTo(context, RateAppScreen());
              }),
              _tileCard(Icons.wb_sunny_outlined, 'Theme Settings', () {
                navigateTo(context, ThemeSelectionScreen());
              }),

              _tileCard(Icons.logout_outlined, 'SignOut', () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return LogInScreen();
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
        trailing: Icon(Icons.arrow_forward_outlined),
        onTap: onTap);
  }

  navigateTo(BuildContext context, Widget nextScreen) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return nextScreen;
    }));
  }
}
