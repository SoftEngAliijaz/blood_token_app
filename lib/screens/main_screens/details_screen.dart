import 'package:blood_token_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final String? requesterName;
  final String? date;
  final String? location;
  final String? bloodType;
  final String? quantityNeeded;
  final String? urgencyLevel;
  final String? contactNumber;
  final String? patientName;
  final String? customLocation;
  final double latitude; // Add latitude parameter
  final double longitude; // Add longitude parameter

  const DetailsScreen({
    Key? key,
    required this.requesterName,
    required this.date,
    required this.location,
    required this.bloodType,
    required this.quantityNeeded,
    required this.urgencyLevel,
    required this.contactNumber,
    required this.patientName,
    required this.customLocation,
    required this.latitude, // Initialize latitude parameter
    required this.longitude, // Initialize longitude parameter
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

              ///share button to share data
              Divider(thickness: 1),
              Center(
                child: TextButton.icon(
                  onPressed: _shareBloodRequestDetails,
                  icon: Icon(
                    Icons.share_outlined,
                    color: AppUtils.redColor,
                  ),
                  label: Text(
                    "Share Details",
                    style: TextStyle(
                      color: AppUtils.redColor,
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListTiles() {
    return [
      _buildListTile(Icons.person_outline, "Requester Name",
          "${widget.requesterName}", Text('${widget.date}')),
      _buildListTile(Icons.emergency_outlined, "Urgency Level",
          "${widget.urgencyLevel}", Text('${widget.date}')),
      _buildListTile(
          Icons.production_quantity_limits_outlined,
          "Quantity Needed",
          "${widget.quantityNeeded}",
          Text('${widget.date}')),
      _buildListTile(Icons.bloodtype_outlined, "Blood Type",
          "${widget.bloodType}", Text('${widget.date}')),
      _buildListTile(Icons.person_2_outlined, "Patient Name",
          "${widget.patientName}", Text('${widget.date}')),
      _buildListTile(Icons.location_city_outlined, "Custom Location",
          "${widget.customLocation}", Text('${widget.date}')),
      _buildListTile(
        Icons.location_city_outlined,
        "Location",
        "${widget.location}",
        IconButton(
          onPressed: () {
            _launchMaps(widget.latitude, widget.longitude);
          },
          icon: const Icon(Icons.arrow_forward_ios_outlined),
        ),
      ),
      _buildListTile(
        Icons.phone_android_outlined,
        "Contact Number",
        "${widget.contactNumber}",

        ///direct caller
        IconButton(
          onPressed: () {
            FlutterPhoneDirectCaller.callNumber("+92${widget.contactNumber}");
          },
          icon: const Icon(Icons.call_outlined),
        ),
      ),
    ];
  }

  Widget _buildListTile(
    IconData leadingIcon,
    String title,
    String subtitle,
    Widget trailingWidget, // Change to accept Text('${widget.date}')able Widget
  ) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailingWidget, // Use the provided trailing widget directly
    );
  }

  void _shareBloodRequestDetails() {
    String message = "🩸 **Blood Request Details** 🩸\n\n";

    // Add only selected details to the message
    if (widget.requesterName != null) {
      message += "• *Requester Name:* ${widget.requesterName}\n\n";
    }
    if (widget.urgencyLevel != null) {
      message += "• *Urgency Level:* ${widget.urgencyLevel}\n\n";
    }
    if (widget.quantityNeeded != null) {
      message += "• *Quantity Needed:* ${widget.quantityNeeded}\n\n";
    }
    if (widget.bloodType != null) {
      message += "• *Blood Type:* ${widget.bloodType}\n\n";
    }
    if (widget.patientName != null) {
      message += "• *Patient Name:* ${widget.patientName}\n\n";
    }
    if (widget.location != null) {
      message += "• *Location:* ${widget.location}\n\n";
    }
    if (widget.contactNumber != null) {
      message += "• *Contact Number:* ${widget.contactNumber}\n\n";
    }

    // Add current time
    String currentTime = DateTime.now().toString();
    message += "• *Time:* $currentTime\n\n";

    message += "Share this blood request with others to help save a life! 💉";

    Share.share(message);
  }

  Future<void> _launchMaps(double latitude, double longitude) async {
    String mapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw Fluttertoast.showToast(msg: 'Could not launch');
    }
  }
}
