import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final bool? isSubmitted;
  final String? patientName;
  final String? date;
  final String? location;
  final String? bloodType;
  final String? submittedBy;

  const DetailsScreen({
    Key? key,
    this.isSubmitted,
    this.patientName,
    this.date,
    this.location,
    this.bloodType,
    this.submittedBy,
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
        title: const Text('Blood Request Details'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Submitted By"),
            subtitle: widget.isSubmitted == true
                ? Text("${widget.submittedBy} On ${widget.date}")
                : const Text("Not Submitted"),
          ),
          ListTile(
            title: const Text("Patient Name"),
            subtitle: Text(widget.patientName!),
          ),
          ListTile(
            title: const Text("Location"),
            subtitle: Text(widget.location!),
          ),
          const ListTile(
            title: Text("Blood Type"),
            subtitle: Text("A+"),
          ),
          const Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.directions_outlined,
                  color: Colors.red,
                ),
                label: const Text(
                  "Get Directions",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.red,
                ),
                label: const Text(
                  "Share",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              shape: const StadiumBorder(),
              height: size.height * 0.060,
              minWidth: size.width * 0.80,
              color: Colors.red,
              child: const Text(
                "Contact",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              shape: const StadiumBorder(),
              height: size.height * 0.060,
              minWidth: size.width * 0.80,
              color: Colors.green,
              child: const Text(
                "Mark as Fulfilled",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
