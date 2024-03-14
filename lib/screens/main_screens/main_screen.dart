import 'package:blood_token_app/models/services_model/blood_request_model.dart'; // Import the BloodRequestModel
import 'package:blood_token_app/screens/main_screens/details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Token'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///Blood Card Element UI
              _buildDonateCard(context, size),

              ///Current Request Element UI
              ListTile(
                title:
                    Text('Current Requests', style: TextStyle(fontSize: 20.0)),
                trailing: Text('See all'),
              ),

              /// Fetch blood requests from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('blood_requests')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator while fetching data
                  }
                  if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Show error if fetching data fails
                  }
                  final List<BloodRequestModel> bloodRequests = snapshot
                      .data!.docs
                      .map((doc) => BloodRequestModel.fromJson(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  return Column(
                    children: bloodRequests.map((value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                          child: Column(
                            children: [
                              ListTile(
                                textColor: Colors.black,
                                title: Text("Name"),
                                subtitle: Text(value.requesterName),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Urgency Level"),
                                    Text(value.urgencyLevel),
                                  ],
                                ),
                              ),
                              ListTile(
                                textColor: Colors.black,
                                title: Text("Location"),
                                subtitle: Text(value.location),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Blood Type"),
                                    Text(value.bloodType),
                                  ],
                                ),
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                                height: size.height * 0.060,
                                minWidth: size.width,
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return DetailsScreen(
                                      requesterName: value.requesterName,
                                      bloodType: value.bloodType,
                                      quantityNeeded: value.quantityNeeded,
                                      urgencyLevel: value.urgencyLevel,
                                      location: value.location,
                                      contactNumber: value.contactNumber,
                                      isSubmitted: false,
                                      patientName: 'N/A',
                                      date: 'N/A',
                                      submittedBy: 'N/A',
                                    );
                                  }));
                                },
                                child: Text(
                                  "Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildDonateCard(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Center(
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "assets/logos/032-blood_bag.svg",
                height: size.height * 0.18,
              ),
              Text(
                "Donate Blood\n Save Lives",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.height * 0.030,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
