import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String bloodGroup;
  final int phoneNumber;
  final int age;
  final dynamic photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.bloodGroup,
    required this.phoneNumber,
    required this.age,
    required this.photoUrl,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? bloodGroup,
    int? phoneNumber,
    int? age,
    dynamic photoUrl,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        age: age ?? this.age,
        photoUrl: photoUrl ?? this.photoUrl,
      );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"] ?? '',
        email: json["email"] ?? '',
        displayName: json["displayName"] ?? '',
        bloodGroup: json["bloodGroup"] ?? '',
        phoneNumber: json["phoneNumber"] ?? 0,
        age: json["age"] ?? '',
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "displayName": displayName,
        "bloodGroup": bloodGroup,
        "phoneNumber": phoneNumber,
        "age": age,
        "photoUrl": photoUrl,
      };
}
