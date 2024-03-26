import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/models/services_model/blood_request_model.dart';
import 'package:blood_token_app/screens/main_screens/details_screen.dart';
import 'package:blood_token_app/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Token'),
      ),
      drawer: CustomDrawer(),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Current Requests',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    trailing: Text('See all'),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('blood_requests')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
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
                                horizontal: 10, vertical: 10),
                            child: Card(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Requester Name",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      "${value.requesterName}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Urgency Level"),
                                        Text(
                                          "${value.urgencyLevel}",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Location"),
                                    subtitle: Text("${value.customLocation}"),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Blood Type"),
                                        Text("${value.bloodType}"),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.watch_outlined),
                                    title:
                                        Text("${value.formattedTimestamp()}"),
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    height: size.height * 0.060,
                                    minWidth: size.width,
                                    color: AppUtils.redColor,
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return DetailsScreen(
                                                requesterName:
                                                    value.requesterName,
                                                bloodType: value.bloodType,
                                                quantityNeeded:
                                                    value.quantityNeeded,
                                                urgencyLevel:
                                                    value.urgencyLevel,
                                                location: value.location,
                                                contactNumber:
                                                    value.contactNumber,
                                                patientName: value.patientName,
                                                date:
                                                    value.formattedTimestamp(),
                                                customLocation:
                                                    value.customLocation,
                                                // Convert latitude string to double
                                                latitude: double.parse(value
                                                    .location!
                                                    .split(', ')[0]),
                                                // Convert longitude string to double
                                                longitude: double.parse(value
                                                    .location!
                                                    .split(', ')[1]));
                                          }));
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Details",
                                      style: TextStyle(
                                        color: AppUtils.whiteColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
