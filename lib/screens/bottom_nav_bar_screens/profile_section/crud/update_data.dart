import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBloodRequestScreen extends StatefulWidget {
  final Map<String, dynamic> requestData;

  const UpdateBloodRequestScreen({super.key, required this.requestData});

  @override
  _UpdateBloodRequestScreenState createState() =>
      _UpdateBloodRequestScreenState();
}

class _UpdateBloodRequestScreenState extends State<UpdateBloodRequestScreen> {
  late TextEditingController _requesterNameController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _quantityNeededController;
  late TextEditingController _urgencyLevelController;
  late TextEditingController _locationController;
  late TextEditingController _contactNumberController;
  late TextEditingController _patientNameController;
  late TextEditingController _customLocationController;

  @override
  void initState() {
    super.initState();
    _requesterNameController =
        TextEditingController(text: widget.requestData['requesterName']);
    _bloodTypeController =
        TextEditingController(text: widget.requestData['bloodType']);
    _quantityNeededController =
        TextEditingController(text: widget.requestData['quantityNeeded']);
    _urgencyLevelController =
        TextEditingController(text: widget.requestData['urgencyLevel']);
    _locationController =
        TextEditingController(text: widget.requestData['location']);
    _contactNumberController =
        TextEditingController(text: widget.requestData['contactNumber']);
    _patientNameController =
        TextEditingController(text: widget.requestData['patientName']);
    _customLocationController =
        TextEditingController(text: widget.requestData['customLocation']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Blood Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _requesterNameController,
                decoration: const InputDecoration(labelText: 'Requester Name'),
              ),
              TextFormField(
                controller: _patientNameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
              ),
              TextFormField(
                controller: _bloodTypeController,
                decoration: const InputDecoration(labelText: 'Blood Type'),
              ),
              TextFormField(
                controller: _quantityNeededController,
                decoration: const InputDecoration(labelText: 'Quantity Needed'),
              ),
              TextFormField(
                controller: _urgencyLevelController,
                decoration: const InputDecoration(labelText: 'Urgency Level'),
              ),
              TextFormField(
                controller: _customLocationController,
                decoration: const InputDecoration(labelText: 'Custom Location'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  updateBloodRequest();
                },
                child: const Text('Update Blood Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateBloodRequest() async {
    try {
      String docId = widget.requestData['docId'];
      await FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(docId)
          .update({
        'requesterName': _requesterNameController.text,
        'patientName': _patientNameController.text,
        'bloodType': _bloodTypeController.text,
        'quantityNeeded': _quantityNeededController.text,
        'urgencyLevel': _urgencyLevelController.text,
        'customLocation': _customLocationController.text,
        'location': _locationController.text,
        'contactNumber': _contactNumberController.text,
      }).whenComplete(() {
        Navigator.pop(context);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blood request updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update blood request')),
      );
    }
  }

  @override
  void dispose() {
    _requesterNameController.dispose();
    _bloodTypeController.dispose();
    _quantityNeededController.dispose();
    _urgencyLevelController.dispose();
    _locationController.dispose();
    _contactNumberController.dispose();
    _patientNameController.dispose();
    _customLocationController.dispose();
    super.dispose();
  }
}
