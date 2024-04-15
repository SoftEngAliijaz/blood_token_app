import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/models/services_model/blood_request_model.dart';
import 'package:blood_token_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  _AddRequestScreenState createState() {
    return _AddRequestScreenState();
  }
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
                        keyboardType: TextInputType.name,
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
                        keyboardType: TextInputType.name,
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
                        keyboardType: TextInputType.name,
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
                        keyboardType: TextInputType.name,
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
                        keyboardType: TextInputType.name,
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
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Address';
                          }
                          return null;
                        },
                        prefixIcon: Icons.location_city_outlined,
                        labelText: 'Address',
                      ),

                      CustomTextFormField(
                        controller: _contactNumberController,
                        keyboardType: TextInputType.phone,
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppUtils.redColor),
                        ),
                        child: Text(
                          'Get Current Location',
                          style: TextStyle(color: AppUtils.whiteColor),
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppUtils.redColor),
                        ),
                        child: Text(
                          _isLoading == false
                              ? 'Submit Data'
                              : 'Submitting Data, Please Wait...',
                          style: TextStyle(color: AppUtils.whiteColor),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: size.height * 0.50,
            width: size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                    child: ListTile(
                        title: Text(
                  _locationController.text.toString().isNotEmpty
                      ? "Location: ${_locationController.text.toString()}"
                      : 'Press on Get Current Location Button',
                ))),
                // CustomTextFormField(
                //   controller: _locationController,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter location';
                //     }
                //     return null;
                //   },
                //   prefixIcon: Icons.location_city_outlined,
                //   labelText: 'Location',
                // ),
                Expanded(
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
              ],
            ),
          ),
        ),
      ],
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
      // Update location controller with latitude and longitude
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
        Fluttertoast.showToast(msg: 'Failed to enable location service');
        return; // Exit function if service couldn't be enabled
      }
      Fluttertoast.showToast(msg: 'Location service is enabled');
    } else {
      Fluttertoast.showToast(msg: 'Location service is enabled');
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Fluttertoast.showToast(msg: 'Location permission denied');
        return; // Exit function if permission couldn't be granted
      }
      Fluttertoast.showToast(msg: 'Location permission granted');
    } else if (_permissionGranted == PermissionStatus.granted) {
      Fluttertoast.showToast(msg: 'Location permission already granted');
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
      setState(() {
        _isLoading = true; // Start loading
      });

      BloodRequestModel bloodRequestObject = BloodRequestModel(
        // Empty docId to let Firestore generate one
        docId: '',
        // Pass the UID of the current user
        uid: FirebaseAuth.instance.currentUser!.uid,
        requesterName: _requesterNameController.text,
        patientName: _patientNameController.text,
        bloodType: _bloodTypeController.text,
        quantityNeeded: _quantityNeededController.text,
        urgencyLevel: _urgencyLevelController.text,
        location: _locationController.text,
        contactNumber: _contactNumberController.text,
        timestamp: DateTime.now(),
        customLocation: _customLocation.text,
        latitude: _initialCameraPosition.latitude,
        longitude: _initialCameraPosition.longitude,
      );

      try {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('blood_requests')
            .add(bloodRequestObject.toJson());

        // Get the document ID assigned by Firestore and update the BloodRequestModel
        String docId = docRef.id;
        bloodRequestObject = bloodRequestObject.copyWith(docId: docId);

        // Update the document with the assigned document ID
        await docRef.update({'docId': docId});

        Fluttertoast.showToast(msg: 'Blood request submitted successfully');
        _resetForm();
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to submit blood request');
      } finally {
        setState(() {
          _isLoading = false; // Stop loading regardless of success or failure
        });
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
    _customLocation.clear();
    setState(() {
      _markers.clear();
    });
  }
}
