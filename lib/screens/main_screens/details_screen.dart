// ignore_for_file: deprecated_member_use
import 'package:blood_token_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
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
  });

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
        title: Text('${requesterName ?? "Details"} Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text("Patient Name"),
            subtitle: Text(patientName ?? "N/A"),
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype_outlined),
            title: const Text("Blood Type"),
            subtitle: Text(bloodType ?? "N/A"),
          ),
          ListTile(
            leading: const Icon(Icons.emergency_outlined),
            title: const Text("Urgency Level"),
            subtitle: Text(urgencyLevel ?? "N/A"),
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits_outlined),
            title: const Text("Quantity Needed"),
            subtitle: Text(quantityNeeded ?? "N/A"),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Requester Name"),
            subtitle: Text(requesterName ?? "N/A"),
          ),
          ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: const Text("Custom Location"),
            subtitle: Text(customLocation ?? "N/A"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: const Text("Location"),
            subtitle: Text(location ?? "N/A"),
            trailing: IconButton.filledTonal(
                onPressed: () {
                  _launchMaps(latitude!, longitude!);
                },
                icon: const Icon(
                  Icons.location_on_outlined,
                  color: AppUtils.redColor,
                )),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android_outlined),
            title: const Text("Contact Number"),
            subtitle: Text(contactNumber ?? "N/A"),
          ),

          ///
          const Divider(thickness: 1),

          ///Call Button & SMS Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///sms button
              Expanded(
                child: Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      await sendSMS("$contactNumber");
                    },
                    icon: const Icon(Icons.message_outlined, color: Colors.red),
                    label: Text("Send SMS to $requesterName",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.red)),
                  ),
                ),
              ),

              ///call button
              Expanded(
                child: Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      await callNumber("+92$contactNumber");
                    },
                    icon: const Icon(Icons.call_outlined, color: Colors.red),
                    label: Text("Call $requesterName",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            ],
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  ///-launch maps
  Future<void> _launchMaps(double latitude, double longitude) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Maps';
    }
  }

  Future<void> callNumber(String phoneNumber) async {
    FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  Future<void> sendSMS(String contactNumber) async {
    final Uri uri = Uri.parse("sms:$contactNumber");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch SMS';
    }
  }
}
