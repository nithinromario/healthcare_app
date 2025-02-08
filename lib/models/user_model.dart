import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserModel {
  final String uid;
  final String email;
  final String userType; // 'patient', 'doctor', 'nurse'
  final String name;
  final String? specialization; // For doctors
  final String? address;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    required this.name,
    this.specialization,
    this.address,
    this.phoneNumber,
    required this.createdAt,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userType': userType,
      'name': name,
      'specialization': specialization,
      'address': address,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated ?? DateTime.now(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      userType: map['userType'] ?? '',
      name: map['name'] ?? '',
      specialization: map['specialization'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastUpdated: map['lastUpdated'] != null 
          ? (map['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserModel.fromFirebaseUser(auth.User user, String userType, String name) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      userType: userType,
      name: name,
      createdAt: DateTime.now(),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? userType,
    String? name,
    String? specialization,
    String? address,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}