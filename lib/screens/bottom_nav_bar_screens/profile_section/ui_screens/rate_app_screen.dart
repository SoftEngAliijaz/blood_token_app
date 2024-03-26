import 'package:blood_token_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({Key? key}) : super(key: key);

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double _userRating = 3; // Initial rating value

  Future<void> _logRating(double rating) async {
    try {
      final String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(DateTime.now());

      // Add rating to Firestore
      await _firestore.collection('ratings').add({
        'rating': rating,
        'timestamp': formattedDateTime,
      });
    } catch (e) {
      print('Error logging rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate This App'),
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
              itemBuilder: (context, _) => Icon(
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
            SizedBox(height: 20),
            Text(
              'Enjoying our app?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please take a moment to rate it on the store.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Log rating to Firestore
                _logRating(_userRating);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppUtils.redColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Rate Now',
                style: TextStyle(fontSize: 20, color: AppUtils.whiteColor),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
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
    if (rating == 5) {
      message = "Wow! Thank you for your excellent rating!";
    } else if (rating >= 4) {
      message = "Thank you for your good rating. We will strive to improve.";
    } else if (rating > 2 && rating < 4) {
      message =
          "Thank you for your rating. We're working on improving your experience.";
    } else if (rating == 2) {
      message =
          "We're sorry you didn't enjoy the app. Please provide feedback on how we can improve.";
    } else if (rating == 1) {
      message =
          "We're sorry to hear that you didn't enjoy the app. Your feedback would be appreciated.";
    } else {
      message = "Invalid rating. Please try again.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rating Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
