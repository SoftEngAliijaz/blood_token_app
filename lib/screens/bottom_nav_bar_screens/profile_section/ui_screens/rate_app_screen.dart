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
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

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
                color: Colors.red,
              ),
              onRatingUpdate: (rating) {
                setState(() {
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
                // TODO: Add functionality to navigate to app store for rating
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Rate Now',
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
