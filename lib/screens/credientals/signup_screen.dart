import 'dart:io';
import 'package:blood_token_app/constants/db_collections.dart';
import 'package:blood_token_app/models/services_model/user_model.dart';
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:blood_token_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscurePassword1 = true;
  bool _isObscurePassword2 = true;
  bool _isLoading = false;
  File? _image;

  _signUpCredentials() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (_passwordController.text != _rePasswordController.text) {
        Fluttertoast.showToast(msg: 'Password and RePassword are not Matched!');
      } else {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          String? photoUrl;
          if (_image != null) {
            photoUrl = await _uploadImage();
          }

          // Create a UserModel instance
          UserModel userModel = UserModel(
            uid: userCredential.user!.uid,
            email: _emailController.text,
            displayName: _nameController.text,
            // Assign value from blood group controller
            bloodGroup: _bloodGroupController.text,
            // Convert text to int
            phoneNumber: int.parse(_phoneNumberController.text),
            // Assign value from age controller
            age: _ageController.text,
            photoUrl: photoUrl,
          );

          // Convert the UserModel instance to a map and save it to Firestore
          await FirebaseFirestore.instance
              .collection(DatabaseCollection.usersCollections)
              .doc(userCredential.user!.uid)
              .set(userModel.toJson());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sign-up successful!"),
            ),
          );

          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return LogInScreen();
          }));
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${e.message}"),
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<String?> _uploadImage() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user_profile_pictures')
        .child('${_emailController.text}_profile_picture.jpg');
    UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.whenComplete(() => null);
    return ref.getDownloadURL();
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),

                              ///AppTitle
                              Container(
                                child: Text(
                                  'Welcome to Blood Token\nPlease SignUp to Your Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              SizedBox(height: 10),

                              GestureDetector(
                                onTap: _getImage,
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: _image == null
                                      ? Colors.red
                                      : Colors.blueGrey,
                                  child: _image == null
                                      ? Center(
                                          child: Icon(Icons.camera_alt_outlined,
                                              color: Colors.white))
                                      : null,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : null,
                                ),
                              ),

                              ///Fields
                              CustomTextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.person_outline,
                                labelText: 'Name',
                              ),
                              CustomTextFormField(
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.email_outlined,
                                labelText: 'Email',
                              ),
                              CustomTextFormField(
                                controller: _ageController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your age';
                                  } else if (int.tryParse(value) == null) {
                                    return 'Please enter a valid age';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.numbers_outlined,
                                labelText: 'Age',
                              ),
                              CustomTextFormField(
                                controller: _phoneNumberController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your phone number';
                                  } else if (!RegExp(r'^\+92[0-9]{10}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid Pakistani phone number';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.phone_android_outlined,
                                prefixText: '+92',
                                labelText: 'Phone Number',
                              ),

                              CustomTextFormField(
                                controller: _bloodGroupController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your blood group';
                                  } else if (!_isValidBloodGroup(value)) {
                                    return 'Please enter a valid blood group';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.bloodtype_outlined,
                                labelText: 'Blood Group',
                              ),

                              ///password fields
                              CustomTextFormField(
                                controller: _passwordController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _isObscurePassword1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.password,
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscurePassword1 =
                                          !_isObscurePassword1;
                                    });
                                  },
                                  icon: Icon(
                                    _isObscurePassword1
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              CustomTextFormField(
                                controller: _rePasswordController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _isObscurePassword2,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please re-enter your password';
                                  } else if (value !=
                                      _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.password,
                                labelText: 'Re-enter Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscurePassword2 =
                                          !_isObscurePassword2;
                                    });
                                  },
                                  icon: Icon(
                                    _isObscurePassword2
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),

                              ///button
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        // Check if an image is selected before proceeding with sign-up
                                        if (_image == null) {
                                          Fluttertoast.showToast(
                                              msg: 'Please Select Image');
                                        } else {
                                          _signUpCredentials();
                                        }
                                      },
                                child: _isLoading
                                    ? const Text('Signing Up...')
                                    : const Text(
                                        'Sign Up',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),

                              ///route selection
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have account?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Sign In",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }

  // Function to validate blood group
  bool _isValidBloodGroup(String value) {
    List<String> validBloodGroups = [
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-',
      'O+',
      'O-',
    ];
    String uppercaseValue = value.toUpperCase();
    return validBloodGroups.contains(uppercaseValue);
  }
}
