import 'dart:io'; // Importing dart:io for File handling

import 'package:blood_token_app/constants/constants.dart'; // Importing constants file
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Cloud Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Importing FirebaseAuth
import 'package:firebase_storage/firebase_storage.dart'; // Importing Firebase Storage
import 'package:flutter/material.dart'; // Importing Flutter Material library
import 'package:fluttertoast/fluttertoast.dart'; // Importing Fluttertoast for toast messages
import 'package:image_picker/image_picker.dart'; // Importing ImagePicker for picking images

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() =>
      _UserProfileScreenState(); // Create state for UserProfileScreen
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _pickedImage; // Variable to store picked image
  final TextEditingController _nameController =
      TextEditingController(); // Controller for name input

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // Get screen size

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // Set app bar title
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(), // Stream for fetching user data from Firestore
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: AppUtils
                    .customProgressIndicator()); // Show progress indicator while loading
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Show error message if any
          } else if (snapshot.hasData && snapshot.data != null) {
            return Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: size.height * 0.80,
                      width: size.width,
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(), // Stream for fetching user data from Firestore
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: AppUtils
                                    .customProgressIndicator()); // Show progress indicator while loading
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error: ${snapshot.error}')); // Show error message if any
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            var user = snapshot.data!;

                            return Card(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Container(
                                width: size.width,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheetSuggestions(
                                                context); // Show modal bottom sheet for image selection
                                          },
                                          child: Container(
                                            height: size.height,
                                            width: size.width,
                                            child: _pickedImage != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    child: Container(
                                                      width: 200,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: FileImage(
                                                              _pickedImage!),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : user['photoUrl'] != null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                        child: Container(
                                                          width: 200,
                                                          height: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero,
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  user[
                                                                      'photoUrl']),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const Icon(Icons.person,
                                                        size: 80),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              profileCard('Name',
                                                  '${user['displayName']}'), // Display user name
                                              profileCard('Email',
                                                  '${user['email']}'), // Display user email
                                              profileCard('Age',
                                                  '${user['age']}'), // Display user age
                                              profileCard('Blood Group',
                                                  '${user['bloodGroup']}'), // Display user blood group
                                              profileCard('Phone',
                                                  '+92${user['phoneNumber']}'), // Display user phone number
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                                child: Text(
                                    'No user data found.')); // Show message if no user data found
                          }
                        },
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppUtils.redColor)), // Set button background color
                  child: const Text('Update/Save',
                      style: TextStyle(
                          color: AppUtils.whiteColor)), // Set button text
                  onPressed: () {
                    var user = snapshot.data;
                    _updateProfile(user!.id); // Call update profile function
                  },
                ),
              ],
            );
          } else {
            return const Center(
                child: Text(
                    'No user data found.')); // Show message if no user data found
          }
        },
      ),
    );
  }

  Widget profileCard(
    String title,
    String trailing,
  ) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      trailing: Text(
        trailing,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  void showModalBottomSheetSuggestions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: Wrap(
            children: [
              ListTile(
                leading:
                    const Icon(Icons.camera_alt_outlined), // Icon for camera
                title: const Text(
                    'Pick From Camera'), // Text for picking from camera
                onTap: () =>
                    _pickFromCamera(), // Call pick from camera function
              ),
              ListTile(
                leading:
                    const Icon(Icons.image_search_outlined), // Icon for gallery
                title: const Text(
                    'Pick From Gallery'), // Text for picking from gallery
                onTap: () =>
                    _pickFromGallery(), // Call pick from gallery function
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    Navigator.pop(context);
    try {
      final XFile? selectedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera); // Pick image from camera
      if (selectedImage != null) {
        setState(() {
          _pickedImage = File(selectedImage.path); // Set picked image
        });
        Fluttertoast.showToast(msg: 'Image Selected'); // Show toast message
      } else {
        Fluttertoast.showToast(msg: 'Image Not Selected'); // Show toast message
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString()); // Show toast message for error
    }
  }

  Future<void> _pickFromGallery() async {
    Navigator.pop(context);
    try {
      final XFile? selectedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery); // Pick image from gallery
      if (selectedImage != null) {
        setState(() {
          _pickedImage = File(selectedImage.path); // Set picked image
        });
        Fluttertoast.showToast(msg: 'Image Selected'); // Show toast message
      } else {
        Fluttertoast.showToast(msg: 'Image Not Selected'); // Show toast message
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString()); // Show toast message for error
    }
  }

  Future<String?> uploadImageAndGetDownloadURL(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(
              'user_profile_image.jpg'); // Set storage reference for profile image
      UploadTask uploadTask =
          storageRef.putFile(imageFile); // Upload image to storage
      TaskSnapshot taskSnapshot = await uploadTask
          .whenComplete(() => null); // Wait for upload completion
      String downloadURL = await taskSnapshot.ref
          .getDownloadURL(); // Get download URL for uploaded image

      return downloadURL; // Return download URL
    } catch (e) {
      print('Error uploading image: $e'); // Print error message
      return null; // Return null in case of error
    }
  }

  void _updateProfile(String userId) async {
    String newName =
        _nameController.text.trim(); // Get new name from text controller

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get(); // Fetch current user data

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>; // Get current user data

      if (newName.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(newName); // Update display name if not empty
        userData['displayName'] = newName; // Update display name in user data
      }

      if (_pickedImage != null) {
        String? downloadURL = await uploadImageAndGetDownloadURL(
            _pickedImage!); // Upload profile image if selected

        if (downloadURL != null) {
          userData['photoUrl'] = downloadURL; // Update photo URL in user data
          setState(() {
            _pickedImage = _pickedImage; // Update picked image in state
          });
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(userData); // Update user data in Firestore

      Fluttertoast.showToast(
          msg: 'Profile updated successfully'); // Show toast message
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to update profile: $e'); // Show toast message for error
    }
  }
}
