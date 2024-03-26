import 'dart:io';

import 'package:blood_token_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _pickedImage;
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
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
                                                context);
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
                                                : user['photoURL'] != null
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
                                                                      'photoURL']),
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
                                                  '${user['displayName']}'),
                                              profileCard(
                                                  'Email', '${user['email']}'),
                                              profileCard(
                                                  'Age', '${user['age']}'),
                                              profileCard('Blood Group',
                                                  '${user['bloodGroup']}'),
                                              profileCard('Phone',
                                                  '+92${user['phoneNumber']}'),
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
                            return Center(child: Text('No user data found.'));
                          }
                        },
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
                    var user = snapshot.data;
                    _updateProfile(user!.id);
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
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Pick From Camera'),
                onTap: () => _pickFromCamera(),
              ),
              ListTile(
                leading: const Icon(Icons.image_search_outlined),
                title: const Text('Pick From Gallery'),
                onTap: () => _pickFromGallery(),
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
      final XFile? selectedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (selectedImage != null) {
        setState(() {
          _pickedImage = File(selectedImage.path);
        });
        Fluttertoast.showToast(msg: 'Image Selected');
      } else {
        Fluttertoast.showToast(msg: 'Image Not Selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _pickFromGallery() async {
    Navigator.pop(context);
    try {
      final XFile? selectedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        setState(() {
          _pickedImage = File(selectedImage.path);
        });
        Fluttertoast.showToast(msg: 'Image Selected');
      } else {
        Fluttertoast.showToast(msg: 'Image Not Selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  ///
  Future<String?> uploadImageAndGetDownloadURL(File imageFile) async {
    try {
      /// Upload the image to Firebase Storage and get the download URL using Firebase Storage:
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('user_profile_image.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // For simplicity, let's assume we have the downloadURL (replace this with your actual logic)
      // String downloadURL = 'https://example.com/path/to/downloaded/image.jpg';

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _updateProfile(String userId) async {
    String newName = _nameController.text.trim();

    try {
      // Fetch current user data
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Get current user data
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Update display name if it's not empty
      if (newName.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
        userData['displayName'] = newName;
      }

      // Upload and update profile image if it's selected
      if (_pickedImage != null) {
        String? downloadURL = await uploadImageAndGetDownloadURL(_pickedImage!);

        if (downloadURL != null) {
          // Update 'photoURL' in Firestore with the download URL
          userData['photoURL'] = downloadURL;

          // Update the state to reflect the new picked image
          setState(() {
            _pickedImage = _pickedImage;
          });
        }
      }

      // Update Firestore document with the new user data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(userData);

      Fluttertoast.showToast(msg: 'Profile updated successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update profile: $e');
    }
  }
}
