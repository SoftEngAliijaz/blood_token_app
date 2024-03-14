import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatefulWidget {
  final bool? isSubmitted;
  final String? patientName;
  final String? date;
  final String? location;
  final String? bloodType;
  final String? quantityNeeded;
  final String? urgencyLevel;
  final String? contactNumber;
  final String? requesterName;
  final String? customLocation;

  const DetailsScreen({
    Key? key,
    required this.isSubmitted,
    required this.patientName,
    required this.date,
    required this.location,
    required this.bloodType,
    required this.quantityNeeded,
    required this.urgencyLevel,
    required this.contactNumber,
    required this.requesterName,
    required this.customLocation,
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
                    color: Colors.red,
                  ),
                  label: Text(
                    "Share Details",
                    style: TextStyle(
                      color: Colors.red,
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
          onPressed: () async {},
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
    Widget?
        trailingWidget, // Change to accept Text('${widget.date}')able Widget
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
}
