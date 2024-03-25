import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBloodRequestsScreen extends StatelessWidget {
  const MyBloodRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Blood Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Filter the collection based on the current user's ID
        stream: FirebaseFirestore.instance
            .collection("blood_requests")
            .where("uid", isEqualTo: user!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No blood requests found.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var requestData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              // Ensure that the blood request belongs to the current user
              if (requestData['uid'] == user.uid) {
                return buildBloodRequestCard(requestData);
              } else {
                // If the blood request does not belong to the current user, return an empty SizedBox
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  Widget buildBloodRequestCard(Map<String, dynamic> requestData) {
    return Card(
      child: ListTile(
        title: Text("${requestData['requesterName']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSubtitleText('Blood Type', requestData['bloodType']),
            buildSubtitleText('Quantity Needed', requestData['quantityNeeded']),
            buildSubtitleText('Urgency Level', requestData['urgencyLevel']),
            buildSubtitleText('Location', requestData['location']),
            buildSubtitleText('Contact Number', requestData['contactNumber']),
            buildSubtitleText('Custom Location', requestData['customLocation']),
            buildSubtitleText('Patient Name', requestData['patientName']),
            buildSubtitleText(
                'Timestamp', formatDate(requestData['timestamp'])),
          ],
        ),
      ),
    );
  }

  Widget buildSubtitleText(String label, dynamic value) {
    return Text('$label: ${value ?? 'N/A'}');
  }

  String formatDate(dynamic timestamp) {
    if (timestamp != null) {
      return DateFormat.yMMMMd('en_US').add_jm().format(
            DateTime.parse(timestamp.toString()).toLocal(),
          );
    }
    return 'N/A';
  }
}
