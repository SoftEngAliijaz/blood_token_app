import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  // Constants for commonly used colors
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color redColor = Color(0xFFFF0000);
  static const Color blueColor = Color(0xFF0000FF);

  // Widget to display a custom progress indicator
  static Center customProgressIndicator() => Center(
        child: CircularProgressIndicator(
          color: redColor,
          backgroundColor: whiteColor,
        ),
      );

  // Function to share blood request details
  static void shareBloodRequestDetails({
    required String? requesterName,
    required String? urgencyLevel,
    required String? quantityNeeded,
    required String? bloodType,
    required String? patientName,
    required String? location,
    required String? contactNumber,
  }) {
    String message =
        "🩸 **Blood Request Details** 🩸\n\n"; // Initial message header
    print(message);

    // Append each detail to the message if available
    if (requesterName != null) {
      message += "• *Requester Name:* $requesterName\n\n";
    }
    if (urgencyLevel != null) {
      message += "• *Urgency Level:* $urgencyLevel\n\n";
    }
    if (quantityNeeded != null) {
      message += "• *Quantity Needed:* $quantityNeeded\n\n";
    }
    if (bloodType != null) {
      message += "• *Blood Type:* $bloodType\n\n";
    }
    if (patientName != null) {
      message += "• *Patient Name:* $patientName\n\n";
    }
    if (location != null) {
      message += "• *Location:* $location\n\n";
    }
    if (contactNumber != null) {
      message += "• *Contact Number:* $contactNumber\n\n";
    }

    // Append current time to the message
    String currentTime = DateTime.now().toString();
    message += "• *Time:* $currentTime\n\n";

    // Additional message to encourage sharing
    message += "Share this blood request with others to help save a life! 💉";
  }

  // Function to launch a URL
  static Future<bool> launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString()); // Launch URL
      return true; // Return true if successful
    } else {
      return false; // Return false if launch fails
    }
  }
}
