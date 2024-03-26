import 'package:blood_token_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBloodRequestsScreen extends StatelessWidget {
  const MyBloodRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Blood Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Filter the collection based on the current user's UID
        stream: FirebaseFirestore.instance
            .collection("blood_requests")
            .where("uid", isEqualTo: currentUserId)
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
              if (requestData['uid'] == currentUser!.uid) {
                return buildBloodRequestCard(requestData, context);
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

  Widget buildBloodRequestCard(
      Map<String, dynamic> requestData, BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Requester Name: ${requestData['requesterName']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSubtitleText('Blood Type', requestData['bloodType']),
                buildSubtitleText(
                    'Quantity Needed', requestData['quantityNeeded']),
                buildSubtitleText('Urgency Level', requestData['urgencyLevel']),
                buildSubtitleText('Location', requestData['location']),
                buildSubtitleText(
                    'Contact Number', requestData['contactNumber']),
                buildSubtitleText(
                    'Custom Location', requestData['customLocation']),
                buildSubtitleText('Patient Name', requestData['patientName']),
                buildSubtitleText(
                    'Timestamp', formatDate(requestData['timestamp'])),
              ],
            ),
            SizedBox(height: 5), // Add spacing between the text and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppUtils.blueColor),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Update",
                      style: TextStyle(color: AppUtils.whiteColor),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppUtils.redColor),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Delete"),
                            content: Text(
                                "Are you sure you want to delete this blood request?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Get the document ID of the blood request to be deleted
                                  String docId = requestData['docId'];

                                  try {
                                    // Perform delete operation in Firestore
                                    await FirebaseFirestore.instance
                                        .collection('blood_requests')
                                        .doc(docId)
                                        .delete();

                                    // Delete successful, show a success message or perform any additional actions
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Blood request deleted successfully'),
                                      ),
                                    );
                                  } catch (e) {
                                    // Handle any errors that occur during deletion
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to delete blood request'),
                                      ),
                                    );
                                  }

                                  Navigator.of(context).pop();
                                },
                                child: Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: AppUtils.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubtitleText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text('$label: ${value ?? 'N/A'}'),
    );
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
