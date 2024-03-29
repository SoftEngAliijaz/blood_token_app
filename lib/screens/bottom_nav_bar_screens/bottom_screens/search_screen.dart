import 'package:blood_token_app/models/services_model/blood_request_model.dart';
import 'package:blood_token_app/screens/main_screens/details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late List<BloodRequestModel> _bloodRequests;
  late List<BloodRequestModel> _filteredRequests;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _bloodRequests = [];
    _filteredRequests = [];
    _fetchBloodRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchBloodRequests() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('blood_requests').get();
      List<BloodRequestModel> requests = snapshot.docs
          .map((doc) =>
              BloodRequestModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        _bloodRequests = requests;
        _filteredRequests = requests;
      });
    } catch (error) {
      print('Error fetching blood requests: $error');
    }
  }

  void _filterRequests(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredRequests = _bloodRequests;
      } else {
        _filteredRequests = _bloodRequests
            .where((request) => request.requesterName!
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterRequests(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for requester name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRequests.length,
              itemBuilder: (context, index) {
                BloodRequestModel request = _filteredRequests[index];
                return ListTile(
                  title: Text("${request.requesterName}"), // Corrected
                  subtitle: Text("${request.urgencyLevel}"), // Corrected
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(
                          requesterName: request.requesterName,
                          bloodType: request.bloodType,
                          quantityNeeded: request.quantityNeeded,
                          urgencyLevel: request.urgencyLevel,
                          location: request.location,
                          contactNumber: request.contactNumber,
                          patientName: request.patientName,
                          date: request.formattedTimestamp(),
                          customLocation: request.customLocation,
                          latitude:
                              double.parse(request.location!.split(', ')[0]),
                          longitude:
                              double.parse(request.location!.split(', ')[1]),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
