import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:share_plus/share_plus.dart';

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
          "${widget.requesterName}", null),
      _buildListTile(Icons.emergency_outlined, "Urgency Level",
          "${widget.urgencyLevel}", null),
      _buildListTile(Icons.production_quantity_limits_outlined,
          "Quantity Needed", "${widget.quantityNeeded}", null),
      _buildListTile(
          Icons.bloodtype_outlined, "Blood Type", "${widget.bloodType}", null),
      _buildListTile(Icons.person_2_outlined, "Patient Name",
          "${widget.patientName}", null),
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
      _buildListTile(
          Icons.done_all_outlined,
          "Submitted By",
          widget.isSubmitted == true
              ? "${widget.submittedBy} On ${widget.date}"
              : "Not Submitted",
          null),
    ];
  }

  Widget _buildListTile(
    IconData leadingIcon,
    String title,
    String subtitle,
    Widget? trailingWidget, // Change to accept nullable Widget
  ) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailingWidget, // Use the provided trailing widget directly
    );
  }

  void _openMaps() async {}

  void _shareBloodRequestDetails() {
    String message = "🩸 **Blood Request Details** 🩸\n\n"
        "• **Requester Name:** ${widget.requesterName}\n\n"
        "• **Urgency Level:** ${widget.urgencyLevel}\n\n"
        "• **Quantity Needed:** ${widget.quantityNeeded}\n\n"
        "• **Blood Type:** ${widget.bloodType}\n\n"
        "• **Patient Name:** ${widget.patientName ?? 'N/A'}\n\n"
        "• **Location:** ${widget.location}\n\n"
        "• **Contact Number:** ${widget.contactNumber}\n\n"
        "• **Submitted By:** ${widget.isSubmitted == true ? "${widget.submittedBy} On ${widget.date}" : "Not Submitted"}\n\n"
        "Share this blood request with others to help save a life! 💉";

    Share.share(message);
  }
}
