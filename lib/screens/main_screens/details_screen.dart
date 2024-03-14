import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailsScreen extends StatefulWidget {
  final bool? isSubmitted;
  final String? patientName;
  final String? date;
  final String? location;
  final String? bloodType;
  final String? submittedBy;
  final String? quantityNeeded;
  final String? urgencyLevel;
  final String? contactNumber;
  final String? requesterName;

  const DetailsScreen({
    Key? key,
    required this.isSubmitted,
    required this.patientName,
    required this.date,
    required this.location,
    required this.bloodType,
    required this.submittedBy,
    required this.quantityNeeded,
    required this.urgencyLevel,
    required this.contactNumber,
    required this.requesterName,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.requesterName} Details'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: _buildListTiles(),
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.directions_outlined,
                      color: Colors.red,
                    ),
                    label: Text(
                      "Get Directions",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share_outlined,
                      color: Colors.red,
                    ),
                    label: Text(
                      "Share",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  ///direct calling
                  Expanded(
                    child: MaterialButton(
                      shape: StadiumBorder(),
                      height: size.height * 0.060,
                      minWidth: size.width * 0.80,
                      color: Colors.red,
                      child: Text(
                        "Direct Call",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        FlutterPhoneDirectCaller.callNumber(
                            "+92${widget.contactNumber}");
                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      shape: StadiumBorder(),
                      height: size.height * 0.060,
                      minWidth: size.width * 0.80,
                      color: Colors.green,
                      child: Text(
                        "Mark as Fulfilled",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: 'This feature is not added yet');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListTiles() {
    return [
      _buildListTile("Requester Name", "${widget.requesterName}"),
      _buildListTile("Urgency Level", "${widget.urgencyLevel}"),
      _buildListTile("Quantity Needed", "${widget.quantityNeeded}"),
      _buildListTile("Blood Type", "${widget.bloodType}"),
      _buildListTile("Patient Name", "${widget.patientName}"),
      _buildListTile("Location", "${widget.location}"),
      _buildListTile("Contact Number", "${widget.contactNumber}"),
      _buildListTile(
          "Submitted By",
          widget.isSubmitted == true
              ? "${widget.submittedBy} On ${widget.date}"
              : "Not Submitted"),
    ];
  }

  Widget _buildListTile(
    String title,
    String subtitle,
  ) {
    return ListTile(
      title: Text("${title}"),
      subtitle: Text("${subtitle}"),
    );
  }
}
