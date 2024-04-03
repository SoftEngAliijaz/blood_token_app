import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color redColor = Color(0xFFFF0000);
  static const Color blueColor = Color(0xFF0000FF);

  static Center customProgressIndicator() => Center(
        child: CircularProgressIndicator(
          color: redColor,
          backgroundColor: whiteColor,
        ),
      );

  static void shareBloodRequestDetails({
    required String? requesterName,
    required String? urgencyLevel,
    required String? quantityNeeded,
    required String? bloodType,
    required String? patientName,
    required String? location,
    required String? contactNumber,
  }) {
    String message = "🩸 **Blood Request Details** 🩸\n\n";
    print(message);

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

    String currentTime = DateTime.now().toString();
    message += "• *Time:* $currentTime\n\n";
    message += "Share this blood request with others to help save a life! 💉";
  }

  static Future<bool> launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
      return true;
    } else {
      return false;
    }
  }
}
