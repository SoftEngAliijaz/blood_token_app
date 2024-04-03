import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final String? requesterName;
  final String? date;
  final String? location;
  final String? bloodType;
  final String? quantityNeeded;
  final String? urgencyLevel;
  final String? contactNumber;
  final String? patientName;
  final String? customLocation;
  final double latitude;
  final double longitude;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${requesterName ?? "Details"} Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildListTile(
              Icons.person_outline, "Requester Name", requesterName ?? ""),
          _buildListTile(
              Icons.emergency_outlined, "Urgency Level", urgencyLevel ?? ""),
          _buildListTile(Icons.production_quantity_limits_outlined,
              "Quantity Needed", quantityNeeded ?? ""),
          _buildListTile(
              Icons.bloodtype_outlined, "Blood Type", bloodType ?? ""),
          _buildListTile(
              Icons.person_2_outlined, "Patient Name", patientName ?? ""),
          _buildListTile(Icons.location_city_outlined, "Custom Location",
              customLocation ?? ""),
          _buildListTile(
              Icons.location_city_outlined, "Location", location ?? "", () {
            _launchMaps(latitude, longitude);
          }),
          _buildListTile(Icons.phone_android_outlined, "Contact Number",
              contactNumber ?? "", () {
            FlutterPhoneDirectCaller.callNumber("+92$contactNumber");
          }),
          Divider(thickness: 1),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse("sms:$contactNumber");
                if (await canLaunch(uri.toString())) {
                  launch(uri.toString());
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

  Widget _buildListTile(IconData leadingIcon, String title, String subtitle,
      [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Future<void> _launchMaps(double latitude, double longitude) async {
    final encodedLat = Uri.encodeComponent(latitude.toString());
    final encodedLong = Uri.encodeComponent(longitude.toString());

    final Uri mapUrl =
        Uri.parse("https://www.google.com/maps/?q=$encodedLat,$encodedLong");

    if (await canLaunch(mapUrl.toString())) {
      await launch(mapUrl.toString());
    } else {
      throw 'Could not launch Maps';
    }
  }
}
