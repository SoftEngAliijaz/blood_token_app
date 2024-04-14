import 'package:blood_token_app/models/services_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:blood_token_app/constants/constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class RateAppScreen extends StatefulWidget {
  final UserModel? currentUser; // Pass UserModel as a parameter

  const RateAppScreen({Key? key, this.currentUser}) : super(key: key);

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double _userRating = 3; // Initial rating value

  Future<void> _logRating(double rating) async {
    try {
      final String formattedDateTime =
          DateFormat('dd-MM-yyyy HH:mm', 'en_US').format(DateTime.now());

      // Add rating to Firestore with user information
      await _firestore.collection('ratings').add({
        'rating': rating,
        'timestamp': formattedDateTime,
        'userId':
            widget.currentUser!.uid, // Associate rating with current user ID
      });

      // Get the user's email
      String userEmail = widget.currentUser!.email;

      // Send email notification
      sendEmail(userEmail, rating);
    } catch (e) {
      debugPrint('Error logging rating: $e');
    }
  }

  void sendEmail(String userEmail, double userRating) async {
    String username = 'softeng.aliijaz@gmail.com'; // Your email address
    String password = '123123'; // Your email password
    String appName = 'Blood Token';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, appName)
      ..recipients.add(userEmail)
      ..subject = 'New Rating Received'
      ..text = 'You received a new rating of $userRating stars.';

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
    } catch (e) {
      debugPrint('Error sending email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate This App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: _userRating,
              minRating: 1,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: AppUtils.redColor,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _showRatingMessage(rating);
                  _userRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Enjoying our app, ${widget.currentUser!.displayName}?', // Display user's name from UserModel
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please take a moment to rate it on the store.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Log rating to Firestore
                _logRating(_userRating);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppUtils.redColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Rate Now',
                style: TextStyle(fontSize: 20, color: AppUtils.whiteColor),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Maybe Later',
                style: TextStyle(fontSize: 18, color: AppUtils.blueColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingMessage(double rating) {
    String message;
    String userName =
        widget.currentUser!.displayName; // Get user's name from UserModel

    if (rating == 5) {
      message = "Wow! Thank you, $userName, for your excellent rating!";
    } else if (rating >= 4) {
      message =
          "Thank you, $userName, for your good rating. We will strive to improve.";
    } else if (rating > 2 && rating < 4) {
      message =
          "Thank you, $userName, for your rating. We're working on improving your experience.";
    } else if (rating == 2) {
      message =
          "We're sorry you didn't enjoy the app, $userName. Please provide feedback on how we can improve.";
    } else if (rating == 1) {
      message =
          "We're sorry to hear that you didn't enjoy the app, $userName. Your feedback would be appreciated.";
    } else {
      message = "Invalid rating. Please try again.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rating Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
