import 'package:blood_token_app/models/blood_card_model.dart';
import 'package:blood_token_app/screens/main_screens/details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool? isDetailsPage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Blood Requests"),
      ),
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
                    color: Colors.white,
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
                          "Donate Blood,\n Save Lives",
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

              ///Text
              ListTile(
                title: Text('Current Requests', style: TextStyle(fontSize: 22)),
              ),

              ///Here We will make cards
              Row(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    child: Row(
                        children: bloodCardModel.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Card(
                          color: Colors.white,
                          shadowColor: Colors.grey,
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
                                title: Text("Patient Name"),
                                subtitle: Text(e.patientName!),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Needed by"),
                                    Text(e.date!),
                                  ],
                                ),
                              ),
                              ListTile(
                                textColor: Colors.black,
                                title: Text("Location"),
                                subtitle: Text(e.location!),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Blood type"),
                                    Text(e.bloodType!),
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
                                  ///Getting Values to next screen
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return DetailsScreen(
                                      isSubmitted: e.isSubmitted,
                                      patientName: e.patientName,
                                      date: e.date,
                                      location: e.location,
                                      bloodType: e.bloodType,
                                      submittedBy: e.submittedBy,
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
                    }).toList()),
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
