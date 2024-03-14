import 'package:blood_token_app/models/services_model/blood_request_model.dart';
import 'package:blood_token_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({Key? key}) : super(key: key);

  @override
  _AddRequestScreenState createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _requesterNameController =
      TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _quantityNeededController =
      TextEditingController();
  final TextEditingController _urgencyLevelController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _customLocation = TextEditingController();

  LatLng _initialCameraPosition = LatLng(0.0, 0.0);
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Blood Request'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            AssetImage("assets/images/blood_token_logo_01.png"),
                      ),
                      CustomTextFormField(
                        controller: _requesterNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter requester name';
                          }
                          return null;
                        },
                        prefixIcon: Icons.person_outlined,
                        labelText: 'Requester Name',
                      ),
                      CustomTextFormField(
                        controller: _patientNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter patient name';
                          }
                          return null;
                        },
                        prefixIcon: Icons.person_outlined,
                        labelText: 'Patient Name',
                      ),
                      CustomTextFormField(
                        controller: _bloodTypeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter blood type';
                          }
                          return null;
                        },
                        prefixIcon: Icons.bloodtype_outlined,
                        labelText: 'Blood Type',
                      ),
                      CustomTextFormField(
                        controller: _quantityNeededController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity needed';
                          }
                          return null;
                        },
                        prefixIcon: Icons.production_quantity_limits_outlined,
                        labelText: 'Quantity Needed',
                      ),
                      CustomTextFormField(
                        controller: _urgencyLevelController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter urgency level';
                          }
                          return null;
                        },
                        prefixIcon: Icons.warning_amber_outlined,
                        labelText: 'Urgency Level',
                      ),
                      CustomTextFormField(
                        controller: _customLocation,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Custom location';
                          }
                          return null;
                        },
                        prefixIcon: Icons.location_city_outlined,
                        labelText: 'Custom Location',
                      ),
                      CustomTextFormField(
                        controller: _locationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location';
                          }
                          return null;
                        },
                        prefixIcon: Icons.location_city_outlined,
                        labelText: 'Location',
                      ),
                      CustomTextFormField(
                        controller: _contactNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter contact number';
                          }
                          return null;
                        },
                        prefixIcon: Icons.phone_android_outlined,
                        labelText: 'Contact Number',
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _getCurrentLocation();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        child: Text(
                          'Get Current Location',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                          height: 10), // Add spacing between button and map
                      _buildGoogleMapLocationDiv(),
                      ElevatedButton(
                        onPressed: () {
                          _submitForm();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        child: _isLoading
                            ? Text(
                                'Submitting...',
                                style: TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleMapLocationDiv() {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 300,
        width: size.width,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        child: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _initialCameraPosition,
            zoom: 15,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          markers: _markers,
          onTap: (position) {
            _addMarker(position);
          },
        ),
      ),
    );
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('user-location'),
          position: position,
        ),
      );
      _locationController.text = "${position.latitude}, ${position.longitude}";
    });
  }

  @override
  void dispose() {
    _requesterNameController.dispose();
    _bloodTypeController.dispose();
    _quantityNeededController.dispose();
    _urgencyLevelController.dispose();
    _locationController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location service is disabled');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Fluttertoast.showToast(msg: 'Location service is still disabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      Fluttertoast.showToast(msg: 'Location permission is denied');
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Fluttertoast.showToast(msg: 'Location permission is still denied');
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _initialCameraPosition =
          LatLng(_locationData.latitude!, _locationData.longitude!);
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialCameraPosition,
          zoom: 15,
        ),
      ));
      _locationController.text =
          "${_locationData.latitude}, ${_locationData.longitude}";
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('user-location'),
          position: _initialCameraPosition,
        ),
      );
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      BloodRequestModel bloodRequestObject = BloodRequestModel(
        requesterName: _requesterNameController.text,
        patientName: _patientNameController.text,
        bloodType: _bloodTypeController.text,
        quantityNeeded: _quantityNeededController.text,
        urgencyLevel: _urgencyLevelController.text,
        location: _locationController.text,
        contactNumber: _contactNumberController.text,
        timestamp: DateTime.now(),
        customLocation: _customLocation.text,
      );

      try {
        await FirebaseFirestore.instance
            .collection('blood_requests')
            .add(bloodRequestObject.toJson());
        Fluttertoast.showToast(msg: 'Blood request submitted successfully');
        _resetForm();
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to submit blood request');
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _requesterNameController.clear();
    _bloodTypeController.clear();
    _quantityNeededController.clear();
    _urgencyLevelController.clear();
    _locationController.clear();
    _contactNumberController.clear();
    setState(() {
      _markers.clear();
    });
  }
}
