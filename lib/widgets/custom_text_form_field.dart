import 'package:blood_token_app/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? onSaved;
  final String? prefixText;
  final TextInputAction? textInputAction;

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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        validator: validator,
        obscureText: obscureText!,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        controller: controller,
        onSaved: onSaved,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          labelText: labelText,
          prefixText: prefixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

///Title Progress Indicator
Widget titleProgressIndicator(BuildContext context, String? title) {
  final Size size = MediaQuery.of(context).size;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Text(
          title ?? "title",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: size.height * 0.030, color: Colors.red),
        ),
      ),
      SizedBox(height: 20),
      Center(
        child: AppUtils.customProgressIndicator(),
      ),
    ],
  );
}
