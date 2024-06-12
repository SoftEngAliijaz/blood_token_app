import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/screens/bottom_nav_bar_screens/bottom_screens/home_screen.dart';
import 'package:blood_token_app/screens/credientals/signup_screen.dart';
import 'package:blood_token_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isObscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('lastResetEmail');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _emailController.text = savedEmail;
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in with Firebase Authentication
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Check if the user exists in Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (userDoc.exists) {
          if (!mounted) return; // Ensure context is still valid
          // User exists in Firestore, navigate to HomeScreen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return const HomeScreen();
          }));
        } else {
          // User doesn't exist in Firestore, display a message to create an account
          if (!mounted) return; // Ensure context is still valid
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("User not found in Database. Please create an account."),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Authentication errors
        if (!mounted) return; // Ensure context is still valid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.message}"),
          ),
        );
      } on FirebaseException catch (e) {
        // Handle Firestore errors
        if (!mounted) return; // Ensure context is still valid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Firestore Error: ${e.message}"),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            color: AppUtils.redColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CircleAvatar(
                      radius: 100,
                      backgroundColor: AppUtils.redColor,
                      backgroundImage:
                          AssetImage("assets/images/blood_token_logo_00.png"),
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        height: size.height * 0.40,
                        width: size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Welcome to Blood Token\nPlease Log In to Your Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0),
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
                              controller: _passwordController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _isObscurePassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              prefixIcon: Icons.password,
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscurePassword = !_isObscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _isObscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppUtils.redColor),
                              ),
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading
                                  ? const Text(
                                      'Logging in...',
                                      style:
                                          TextStyle(color: AppUtils.whiteColor),
                                    )
                                  : const Text(
                                      'Log In',
                                      style:
                                          TextStyle(color: AppUtils.whiteColor),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return const SignUpScreen();
                                    }));
                                  },
                                  child: const Text("Sign Up"),
                                ),
                              ],
                            ),
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
    );
  }
}
