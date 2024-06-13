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

  ///Profile pic
  static const String photoUrl =
      'https://scontent.flhe25-1.fna.fbcdn.net/v/t39.30808-6/438079286_452695837274527_5019610989273186308_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeF_IBQIYzF-HdgLyRTPnONbCNoDGfRzWkQI2gMZ9HNaRLY3JAZzI2SNnWtvYCdlnQNTRJNLMcICnfDDsSX6TI4f&_nc_ohc=yDLADruxxhcQ7kNvgFIM2jo&_nc_ht=scontent.flhe25-1.fna&oh=00_AYBcroq9BVRmIRbt3QhqDzw00Me45oSTO7g6lRYzh3QD9w&oe=6670FADB';
}
