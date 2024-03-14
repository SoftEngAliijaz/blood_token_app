import 'package:flutter/material.dart';

class MyBloodRequestsScreen extends StatelessWidget {
  MyBloodRequestsScreen({Key? key}) : super(key: key);

  // Sample blood request data
  final List<Map<String, String>> myBloodRequests = [
    {
      'requesterName': 'John Doe',
      'bloodType': 'O+',
      'quantityNeeded': '2 units',
      'urgencyLevel': 'High',
      'location': '123 Main St, City',
      'contactNumber': '123-456-7890',
      'submittedBy': 'Jane Smith',
      'date': '2024-03-15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Blood Requests'),
      ),
      body: ListView.builder(
        itemCount: myBloodRequests.length,
        itemBuilder: (BuildContext context, int index) {
          final bloodRequest = myBloodRequests[index];
          return Card(
            child: ExpansionTile(
              children: [
                _buildBloodRequestDetail(
                    'Blood Type', bloodRequest['bloodType']),
                _buildBloodRequestDetail(
                    'Quantity Needed', bloodRequest['quantityNeeded']),
                _buildBloodRequestDetail(
                    'Urgency Level', bloodRequest['urgencyLevel']),
                _buildBloodRequestDetail('Location', bloodRequest['location']),
                _buildBloodRequestDetail(
                    'Contact Number', bloodRequest['contactNumber']),
                _buildBloodRequestDetail(
                    'Submitted By',
                    bloodRequest['submittedBy'] != null
                        ? "${bloodRequest['submittedBy']} On ${bloodRequest['date']}"
                        : 'Not Submitted'),
              ],
              leading: IconButton(
                onPressed: () {
                  // Handle edit button pressed
                },
                icon: const Icon(Icons.edit_outlined),
              ),
              title: Text(bloodRequest['requesterName'] ?? 'Unknown'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBloodRequestDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            title + ': ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }
}
