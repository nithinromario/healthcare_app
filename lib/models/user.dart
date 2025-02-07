import 'package:flutter/foundation.dart';

enum UserType { patient, doctor, nurse }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final String? specialization; // For doctors
  final String? licenseNumber; // For doctors and nurses

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.specialization,
    this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType.toString(),
      'specialization': specialization,
      'licenseNumber': licenseNumber,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['userType']}',
      ),
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
    );
  }
} 