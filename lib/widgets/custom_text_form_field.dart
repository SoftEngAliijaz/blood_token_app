import 'package:blood_token_app/constants/constants.dart'; // Importing constants file
import 'package:flutter/material.dart'; // Importing Flutter Material library

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller; // Controller for text field
  final String? labelText; // Label text for text field
  final IconData? prefixIcon; // Icon displayed before input
  final Widget? suffixIcon; // Widget displayed after input
  final String? Function(String?)? validator; // Validation function for input
  final bool? obscureText; // Whether input should be obscured
  final TextInputType? keyboardType; // Type of keyboard to display
  final String? Function(String?)?
      onSaved; // Function to call when form is saved
  final String? prefixText; // Text displayed before input
  final TextInputAction?
      textInputAction; // Action to take when input is submitted

  const CustomTextFormField({
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.onSaved,
    this.prefixText,
    this.textInputAction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        validator: validator, // Set validation function
        obscureText: obscureText!, // Set whether input should be obscured
        textInputAction: textInputAction, // Set text input action
        keyboardType: keyboardType, // Set keyboard type
        controller: controller, // Set controller
        onSaved: onSaved, // Set function to call when form is saved
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon), // Set prefix icon
          labelText: labelText, // Set label text
          prefixText: prefixText, // Set prefix text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: suffixIcon, // Set suffix icon
        ),
      ),
    );
  }
}

// Title Progress Indicator Widget
Widget titleProgressIndicator(BuildContext context, String? title) {
  final Size size = MediaQuery.of(context).size; // Get device screen size
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Text(
          title ?? "title", // Display provided title or default
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: size.height * 0.030,
              color: AppUtils.redColor), // Set text style
        ),
      ),
      SizedBox(height: 20), // Add spacing
      Center(
        child: AppUtils
            .customProgressIndicator(), // Display custom progress indicator
      ),
    ],
  );
}
