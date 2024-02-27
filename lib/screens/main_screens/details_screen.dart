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
        title: Text('Blood Request Details'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Submitted By"),
            subtitle: widget.isSubmitted == true
                ? Text("${widget.submittedBy} On ${widget.date}")
                : Text("Not Submitted"),
          ),
          ListTile(
            title: Text("Patient Name"),
            subtitle: Text(widget.patientName!),
          ),
          ListTile(
            title: Text("Location"),
            subtitle: Text(widget.location!),
          ),
          ListTile(
            title: Text("Blood Type"),
            subtitle: Text("A+"),
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              shape: StadiumBorder(),
              height: size.height * 0.060,
              minWidth: size.width * 0.80,
              color: Colors.red,
              child: Text(
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
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
