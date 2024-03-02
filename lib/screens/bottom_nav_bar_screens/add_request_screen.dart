import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:blood_token_app/models/services_model/blood_request_model.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({Key? key}) : super(key: key);

  @override
  _AddRequestScreenState createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field
  final TextEditingController _requesterNameController =
      TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _quantityNeededController =
      TextEditingController();
  final TextEditingController _urgencyLevelController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  // Google Maps variables
  GoogleMapController? _mapController;
  LatLng _initialCameraPosition = LatLng(0.0, 0.0);

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
                    _buildGoogleMapLocationDiv(),
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
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, create BloodRequestModel instance
                          BloodRequestModel bloodRequestObject =
                              BloodRequestModel(
                            requesterName: _requesterNameController.text,
                            bloodType: _bloodTypeController.text,
                            quantityNeeded: _quantityNeededController.text,
                            urgencyLevel: _urgencyLevelController.text,
                            location: _locationController.text,
                            contactNumber: _contactNumberController.text,
                            timestamp: DateTime.now().toString(),
                          );

                          // Store BloodRequestModel to Firestore
                          await FirebaseFirestore.instance
                              .collection('blood_requests')
                              .add(bloodRequestObject.toJson());

                          // You can now use the 'bloodRequestObject' object as needed
                          // For demonstration, let's print it
                          print(bloodRequestObject.toJson());
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
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
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: _initialCameraPosition,
            zoom: 15,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          markers: _buildMarkers(),
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: MarkerId('user-location'),
        position: _initialCameraPosition,
      ),
    };
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    _requesterNameController.dispose();
    _bloodTypeController.dispose();
    _quantityNeededController.dispose();
    _urgencyLevelController.dispose();
    _locationController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }
}
