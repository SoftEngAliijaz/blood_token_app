import 'package:blood_token_app/constants/constants.dart'; // Importing constants file
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Cloud Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Importing FirebaseAuth
import 'package:flutter/material.dart'; // Importing Flutter Material library
import 'package:intl/intl.dart'; // Importing Intl for date formatting

class MyBloodRequestsScreen extends StatelessWidget {
  const MyBloodRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blood Requests'), // Set app bar title
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
              child: AppUtils
                  .customProgressIndicator(), // Show progress indicator while loading
            );
          }
          if (snapshot.hasError) {
            return Center(
              child:
                  Text('Error: ${snapshot.error}'), // Show error message if any
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Requestes Found.',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  SizedBox(height: 10),
                  AppUtils.customProgressIndicator()
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var requestData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              // Ensure that the blood request belongs to the current user
              if (requestData['uid'] == currentUser!.uid) {
                return buildBloodRequestCard(
                    requestData, context); // Build blood request card
              } else {
                // If the blood request does not belong to the current user, return an empty SizedBox
                return const SizedBox.shrink();
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Requester Name: ${requestData['requesterName']}", // Display requester name
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSubtitleText('Blood Type',
                    requestData['bloodType']), // Display blood type
                buildSubtitleText('Quantity Needed',
                    requestData['quantityNeeded']), // Display quantity needed
                buildSubtitleText('Urgency Level',
                    requestData['urgencyLevel']), // Display urgency level
                buildSubtitleText(
                    'Location', requestData['location']), // Display location
                buildSubtitleText('Contact Number',
                    requestData['contactNumber']), // Display contact number
                buildSubtitleText('Custom Location',
                    requestData['customLocation']), // Display custom location
                buildSubtitleText('Patient Name',
                    requestData['patientName']), // Display patient name
                buildSubtitleText('Timestamp',
                    formatDate(requestData['timestamp'])), // Display timestamp
              ],
            ),
            const SizedBox(
                height: 5), // Add spacing between the text and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///update data button
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppUtils.blueColor), // Set button background color
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Update", // Set button text
                      style: TextStyle(
                          color: AppUtils.whiteColor), // Set button text color
                    ),
                  ),
                ),

                ///delete data button
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppUtils.redColor), // Set button background color
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Delete"), // Dialog title
                            content: const Text(
                                "Are you sure you want to delete this blood request?"), // Dialog content
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog without deleting
                                },
                                child:
                                    const Text("Cancel"), // Cancel button text
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
                                      const SnackBar(
                                        content: Text(
                                            'Blood request deleted successfully'), // Show success message
                                      ),
                                    );
                                  } catch (e) {
                                    // Handle any errors that occur during deletion
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to delete blood request'), // Show error message
                                      ),
                                    );
                                  }

                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child:
                                    const Text("Delete"), // Delete button text
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Delete", // Set button text
                      style: TextStyle(
                          color: AppUtils.whiteColor), // Set button text color
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
          ); // Format timestamp
    }
    return 'N/A';
  }
}
