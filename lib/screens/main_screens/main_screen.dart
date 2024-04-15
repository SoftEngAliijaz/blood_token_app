import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/models/services_model/blood_request_model.dart';
import 'package:blood_token_app/screens/main_screens/details_screen.dart';
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
        title: const Text('Blood Token'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              child: Padding(
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
            ),
            const ListTile(
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
                  return AppUtils.customProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final List<BloodRequestModel> bloodRequests = snapshot
                    .data!.docs
                    .map((doc) => BloodRequestModel.fromJson(
                        doc.data() as Map<String, dynamic>))
                    .toList();

                return SizedBox(
                  height: 300, // Adjust the height as needed
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: bloodRequests.map((value) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            width: size.width * 0.90,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.grey.shade100,
                                width: 0.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: const Text(
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
                                        const Text("Urgency Level"),
                                        Text(
                                          "${value.urgencyLevel}",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: const Text("Location"),
                                    subtitle: Text("${value.customLocation}"),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Blood Type"),
                                        Text("${value.bloodType}"),
                                      ],
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.watch_outlined),
                                  title: Text(value.formattedTimestamp()),
                                ),
                                MaterialButton(
                                  shape: const RoundedRectangleBorder(
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
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return DetailsScreen(
                                            requesterName: value.requesterName,
                                            bloodType: value.bloodType,
                                            quantityNeeded:
                                                value.quantityNeeded,
                                            urgencyLevel: value.urgencyLevel,
                                            location: value.location,
                                            contactNumber: value.contactNumber,
                                            patientName: value.patientName,
                                            date: value.formattedTimestamp(),
                                            customLocation:
                                                value.customLocation,
                                            // Convert latitude string to double
                                            latitude: double.parse(
                                                value.location!.split(', ')[0]),
                                            // Convert longitude string to double
                                            longitude: double.parse(value
                                                .location!
                                                .split(', ')[1]));
                                      }));
                                    }
                                  },
                                  child: const Text(
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
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
