import 'package:flutter/material.dart';

class AppUtils {
  // Constants for commonly used colors
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color redColor = Color(0xFFFF0000);
  static const Color blueColor = Color(0xFF0000FF);

  // Widget to display a custom progress indicator
  static Center customProgressIndicator() => const Center(
        child: CircularProgressIndicator(
          color: redColor,
          backgroundColor: blueColor,
        ),
      );
}
