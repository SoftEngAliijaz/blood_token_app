import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  // Constructor to initialize details of the request
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
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  // Variables to hold details of the request
  final String? requesterName;
  final String? date;
  final String? location;
  final String? bloodType;
  final String? quantityNeeded;
  final String? urgencyLevel;
  final String? contactNumber;
  final String? patientName;
  final String? customLocation;
  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${requesterName ?? "Details"} Details'), // Displaying the requester's name or default if not available
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // List of details displayed as ListTile
          _buildListTile(Icons.person_outline, "Requester Name",
              requesterName ?? "N/A"), // Display requester's name
          _buildListTile(Icons.emergency_outlined, "Urgency Level",
              urgencyLevel ?? "N/A"), // Display urgency level
          _buildListTile(
              Icons.production_quantity_limits_outlined,
              "Quantity Needed",
              quantityNeeded ?? "N/A"), // Display quantity of blood needed
          _buildListTile(Icons.bloodtype_outlined, "Blood Type",
              bloodType ?? "N/A"), // Display required blood type
          _buildListTile(Icons.person_2_outlined, "Patient Name",
              patientName ?? "N/A"), // Display patient's name
          _buildListTile(Icons.location_city_outlined, "Custom Location",
              customLocation ?? "N/A"), // Display custom location
          _buildListTile(
              Icons.location_city_outlined, "Location", location ?? "N/A", () {
            _launchMaps(latitude!,
                longitude!); // Launch maps with latitude and longitude on tap
          }),
          _buildListTile(Icons.phone_android_outlined, "Contact Number",
              contactNumber ?? "N/A", () {
            FlutterPhoneDirectCaller.callNumber(
                "+92$contactNumber"); // Direct call to contact number
          }),
          Divider(thickness: 1),
          // Button to send SMS
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse("sms:$contactNumber"); // Prepare SMS URI
                if (await canLaunch(uri.toString())) {
                  launch(uri.toString()); // Launch SMS app if available
                } else {
                  throw 'Could not launch SMS';
                }
              },
              icon: Icon(Icons.message_outlined, color: Colors.red),
              label: Text("Send SMS", style: TextStyle(color: Colors.red)),
            ),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }

  // Widget to build ListTile
  Widget _buildListTile(IconData leadingIcon, String title, String subtitle,
      [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  // Function to launch maps with latitude and longitude
  Future<void> _launchMaps(double latitude, double longitude) async {
    final encodedLat =
        Uri.encodeComponent(latitude.toString()); // Encode latitude
    final encodedLong =
        Uri.encodeComponent(longitude.toString()); // Encode longitude

    final Uri mapUrl = Uri.parse(
        "https://www.google.com/maps/?q=$encodedLat,$encodedLong"); // Prepare maps URL with encoded latitude and longitude

    if (await canLaunch(mapUrl.toString())) {
      await launch(mapUrl.toString()); // Launch maps with prepared URL
    } else {
      throw 'Could not launch Maps';
    }
  }
}
