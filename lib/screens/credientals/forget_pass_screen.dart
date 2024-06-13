import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/screens/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      toast.Fluttertoast.showToast(
          msg: 'Password reset email sent successfully.');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastResetEmail', email);

      if (!mounted) return; // Ensure context is still valid before navigating
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const LogInScreen();
      }));
    } catch (e) {
      toast.Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: AppUtils.customProgressIndicator(),
            )
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
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: 'Enter Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                AppUtils.redColor),
                          ),
                          child: const Text('Send Request'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String email = emailController.text.trim();
                              resetPassword(context, email);
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
