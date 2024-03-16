import 'package:flutter/material.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share This App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Icon(
                  Icons.share,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Share our app with others!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Help us grow by sharing the app with your friends and family.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Add functionality to share the app
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Share Now',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Maybe Later',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
