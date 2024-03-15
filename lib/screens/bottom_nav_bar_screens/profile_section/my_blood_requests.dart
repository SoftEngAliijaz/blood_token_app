import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';

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
            .where("userId",
                isEqualTo: user
                    ?.uid) // Assuming userId is the field representing the user ID
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
              if (requestData.isEmpty) {
                // Handle the case where requestData is null
                return SizedBox.shrink();
              }
              return Card(
                child: ListTile(
                  title: Text("${requestData['requesterName']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Blood Type: ${requestData['bloodType'] ?? ''}'),
                      Text(
                          'Quantity Needed: ${requestData['quantityNeeded'] ?? ''}'),
                      Text(
                          'Urgency Level: ${requestData['urgencyLevel'] ?? ''}'),
                      Text('Location: ${requestData['location'] ?? ''}'),
                      Text(
                          'Contact Number: ${requestData['contactNumber'] ?? ''}'),
                      Text(
                          'Custom Location: ${requestData['customLocation'] ?? ''}'),
                      Text('Patient Name: ${requestData['patientName'] ?? ''}'),
                      Text(
                          'Timestamp: ${requestData['timestamp'] != null ? DateTime.parse(requestData['timestamp'].toString()).toString() : ''}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
