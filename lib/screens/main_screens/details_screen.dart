import 'package:blood_token_app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
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
            onTap: () {
              _launchMaps(latitude!, longitude!);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: const Text("Location"),
            subtitle: Text(location ?? "N/A"),
            trailing: IconButton.filledTonal(
                onPressed: () {},
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
                      final uri = Uri.parse("sms:$contactNumber");
                      if (await canLaunch(uri.toString())) {
                        launch(uri.toString());
                      } else {
                        throw 'Could not launch SMS';
                      }
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
                    onPressed: () async {},
                    icon: const Icon(Icons.message_outlined, color: Colors.red),
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
