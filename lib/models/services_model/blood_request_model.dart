import 'dart:convert';

class BloodRequestModel {
  final String? requesterName;
  final String? bloodType;
  final String? quantityNeeded;
  final String? urgencyLevel;
  final String? location;
  final String? contactNumber;
  final String? customLocation;
  final String? patientName;
  final DateTime? timestamp;

  BloodRequestModel({
    required this.requesterName,
    required this.bloodType,
    required this.quantityNeeded,
    required this.urgencyLevel,
    required this.location,
    required this.contactNumber,
    required this.customLocation,
    required this.patientName,
    required this.timestamp,
  });

  BloodRequestModel copyWith({
    String? requesterName,
    String? bloodType,
    String? quantityNeeded,
    String? urgencyLevel,
    String? location,
    String? contactNumber,
    String? customLocation,
    String? patientName,
    DateTime? timestamp,
  }) =>
      BloodRequestModel(
        requesterName: requesterName ?? this.requesterName,
        bloodType: bloodType ?? this.bloodType,
        quantityNeeded: quantityNeeded ?? this.quantityNeeded,
        urgencyLevel: urgencyLevel ?? this.urgencyLevel,
        location: location ?? this.location,
        contactNumber: contactNumber ?? this.contactNumber,
        customLocation: customLocation ?? this.customLocation,
        patientName: patientName ?? this.patientName,
        timestamp: timestamp ?? this.timestamp,
      );

  factory BloodRequestModel.fromRawJson(String str) =>
      BloodRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) =>
      BloodRequestModel(
        requesterName: json["requesterName"],
        bloodType: json["bloodType"],
        quantityNeeded: json["quantityNeeded"],
        urgencyLevel: json["urgencyLevel"],
        location: json["location"],
        contactNumber: json["contactNumber"],
        customLocation: json["customLocation"],
        patientName: json["patientName"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "requesterName": requesterName,
        "bloodType": bloodType,
        "quantityNeeded": quantityNeeded,
        "urgencyLevel": urgencyLevel,
        "location": location,
        "contactNumber": contactNumber,
        "customLocation": customLocation,
        "patientName": patientName,
        "timestamp": timestamp!.toIso8601String(),
      };
}
