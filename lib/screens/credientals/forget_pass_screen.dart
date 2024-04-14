import 'package:blood_token_app/constants/constants.dart'; // Importing constants file
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importing FirebaseAuth
import 'package:flutter/material.dart'; // Importing Flutter Material library
import 'package:fluttertoast/fluttertoast.dart'
    as toast; // Importing Fluttertoast for toast messages
import 'package:shared_preferences/shared_preferences.dart'; // Importing SharedPreferences

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState(); // Create state for ForgetPasswordScreen
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController(); // Controller for email input
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Form key for validation
  bool _isLoading = false; // Flag to track loading state

  // Function to reset password
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email); // Send password reset email
      toast.Fluttertoast.showToast(
          msg: 'Password reset email sent successfully.'); // Show toast message

      // Save email to shared preferences for autofill in login screen
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastResetEmail', email);

      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return LogInScreen(); // Navigate to login screen
      }));
    } catch (e) {
      toast.Fluttertoast.showToast(
          msg: e.toString()); // Show error toast message
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: AppUtils
                  .customProgressIndicator()) // Show custom progress indicator if loading
          : SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Forget Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TextFormField for email input
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: 'Enter Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        // ElevatedButton for sending reset request
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppUtils
                                    .redColor), // Set button background color
                          ),
                          child: Text('Send Request'), // Button text
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String email = emailController.text.trim();
                              resetPassword(context,
                                  email); // Call reset password function
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
