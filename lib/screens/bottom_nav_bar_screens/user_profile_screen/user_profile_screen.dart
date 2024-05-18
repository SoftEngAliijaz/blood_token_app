import 'dart:io';
import 'package:blood_token_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _pickedImage;

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

  Future<String?> uploadImageAndGetDownloadURL(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(
              'user_profile_image.jpg');       UploadTask uploadTask =
          storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask
          .whenComplete(() => null);     
      String downloadURL = await taskSnapshot.ref
          .getDownloadURL(); 

      return downloadURL; 
    } catch (e) {
      print('Error uploading image: $e'); 
      return null; 
    }
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

  void _updateProfile(String userId) async {
    String newName = _nameController.text.trim();

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (newName.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
        userData['displayName'] = newName;
      }

      if (_pickedImage != null) {
        String? downloadURL = await uploadImageAndGetDownloadURL(_pickedImage!);

        if (downloadURL != null) {
          userData['photoUrl'] = downloadURL;
          setState(() {
            _pickedImage = _pickedImage;
          });
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(userData);

      Fluttertoast.showToast(msg: 'Profile updated successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: AppUtils.customProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            var user = snapshot.data!;

            return Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: size.height * 0.80,
                      width: size.width,
                      child: Card(
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
                                      showModalBottomSheetSuggestions(context);
                                    },
                                    child: Container(
                                      height: size.height,
                                      width: size.width,
                                      child: _pickedImage != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.zero,
                                              child: Image.file(
                                                _pickedImage!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : (user['photoUrl'] != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  child: Image.network(
                                                    user['photoUrl'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : const Icon(Icons.person,
                                                  size: 80)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        profileCard('Name',
                                            '${user['displayName'] ?? ''}'),
                                        profileCard(
                                            'Email', '${user['email'] ?? ''}'),
                                        profileCard(
                                            'Age', '${user['age'] ?? ''}'),
                                        profileCard('Blood Group',
                                            '${user['bloodGroup'] ?? ''}'),
                                        profileCard('Phone',
                                            '+92${user['phoneNumber'] ?? ''}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppUtils.redColor)),
                  child: const Text('Update/Save',
                      style: TextStyle(color: AppUtils.whiteColor)),
                  onPressed: () {
                    _updateProfile(user.id);
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('No user data found.'));
          }
        },
      ),
    );
  }
}
