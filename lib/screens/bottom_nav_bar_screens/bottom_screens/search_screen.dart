import 'dart:async';
import 'package:blood_token_app/models/services_model/blood_request_model.dart';
import 'package:blood_token_app/screens/main_screens/details_screen.dart';
import 'package:blood_token_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? _searchController;
  List<BloodRequestModel>? _bloodRequests;
  List<BloodRequestModel>? _filteredRequests;
  Timer? _debounceTimer;

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
    _searchController!.dispose();
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
      debugPrint('Error fetching blood requests: $error');
    }
  }

  void _filterRequests(String searchText) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if (searchText.isEmpty) {
          _filteredRequests = _bloodRequests;
        } else {
          _filteredRequests = _bloodRequests!
              .where((request) =>
                  request.requesterName!
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  request.bloodType!
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  request.customLocation!
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  request.requesterName!
                      .toUpperCase()
                      .contains(searchText.toUpperCase()) ||
                  request.bloodType!
                      .toUpperCase()
                      .contains(searchText.toUpperCase()) ||
                  request.customLocation!
                      .toUpperCase()
                      .contains(searchText.toUpperCase()))
              .toList();
        }
      });
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController!.clear();
      _filterRequests('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                CustomTextFormField(
                    controller: _searchController,
                    labelText: 'Search...',
                    prefixIcon: Icons.search_outlined,
                    onChanged: _filterRequests),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRequests!.length,
              itemBuilder: (context, index) {
                BloodRequestModel request = _filteredRequests![index];
                return ListTile(
                  title: Text("${request.requesterName}"),
                  subtitle: Text("${request.urgencyLevel}"),
                  trailing: Text("${request.customLocation}"),
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
