import 'dart:convert';

class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? bloodGroup;
  final int? phoneNumber;
  final int? age;
  final dynamic photoUrl;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.bloodGroup,
    this.phoneNumber,
    this.age,
    this.photoUrl,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] as String?,
      email: json["email"] as String?,
      displayName: json["displayName"] as String?,
      bloodGroup: json["bloodGroup"] as String?,
      phoneNumber: json["phoneNumber"] != null
          ? int.tryParse(json["phoneNumber"].toString())
          : null,
      age: json["age"] != null ? int.tryParse(json["age"].toString()) : null,
      photoUrl: json["photoUrl"],
    );
  }

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
