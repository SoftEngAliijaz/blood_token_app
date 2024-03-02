import 'package:blood_token_app/screens/bottom_nav_bar_screens/user/user_profile_screen.dart';
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
                        backgroundImage:
                            AssetImage("assets/images/blood_token_logo_01.png"),
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

            _tileCard(Icons.request_page_outlined, 'My Requests', () {}),

            _tileCard(Icons.share_outlined, 'Share App', () {}),

            _tileCard(Icons.rate_review_outlined, 'Rate Our App', () {}),

            _tileCard(Icons.logout_outlined, 'SignOut', () {}),
          ],
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
