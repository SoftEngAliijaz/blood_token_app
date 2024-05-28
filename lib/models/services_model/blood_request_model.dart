import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BloodRequestModel {
  final String? docId;
  final String? uid;
  final String? requesterName;
  final String? bloodType;
  final String? quantityNeeded;
  final String? urgencyLevel;
  final String? location;
  final String? contactNumber;
  final String? customLocation;
  final String? patientName;
  final DateTime? timestamp;
  final double? latitude;
  final double? longitude;

  BloodRequestModel({
    this.docId,
    this.uid,
    required this.requesterName,
    required this.bloodType,
    required this.quantityNeeded,
    required this.urgencyLevel,
    required this.location,
    required this.contactNumber,
    required this.customLocation,
    required this.patientName,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });

  BloodRequestModel copyWith({
    String? docId,
    String? uid,
    String? requesterName,
    String? bloodType,
    String? quantityNeeded,
    String? urgencyLevel,
    String? location,
    String? contactNumber,
    String? customLocation,
    String? patientName,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
  }) =>
      BloodRequestModel(
        docId: docId ?? this.docId,
        uid: uid ?? this.uid,
        requesterName: requesterName ?? this.requesterName,
        bloodType: bloodType ?? this.bloodType,
        quantityNeeded: quantityNeeded ?? this.quantityNeeded,
        urgencyLevel: urgencyLevel ?? this.urgencyLevel,
        location: location ?? this.location,
        contactNumber: contactNumber ?? this.contactNumber,
        customLocation: customLocation ?? this.customLocation,
        patientName: patientName ?? this.patientName,
        timestamp: timestamp ?? this.timestamp,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory BloodRequestModel.fromRawJson(String str) =>
      BloodRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    try {
      return BloodRequestModel(
        docId: json["docId"],
        uid: json["uid"],
        requesterName: json["requesterName"],
        bloodType: json["bloodType"],
        quantityNeeded: json["quantityNeeded"],
        urgencyLevel: json["urgencyLevel"],
        location: json["location"],
        contactNumber: json["contactNumber"],
        customLocation: json["customLocation"],
        patientName: json["patientName"],
        timestamp: json["timestamp"] != null
            ? DateTime.parse(json["timestamp"])
            : null,
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );
    } catch (e) {
      debugPrint("Error parsing BloodRequestModel from JSON: $e");
      throw Exception("Failed to parse BloodRequestModel");
    }
  }

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "uid": uid,
        "requesterName": requesterName,
        "bloodType": bloodType,
        "quantityNeeded": quantityNeeded,
        "urgencyLevel": urgencyLevel,
        "location": location,
        "contactNumber": contactNumber,
        "customLocation": customLocation,
        "patientName": patientName,
        "timestamp": timestamp?.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
      };

  /// formatted Time Stamp
  String formattedTimestamp() {
    return timestamp != null
        ? DateFormat('dd, MMMM yyyy h:mm a').format(timestamp!.toLocal())
        : 'N/A';
  }
}
