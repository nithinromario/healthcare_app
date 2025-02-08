import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String patientId;
  final String providerId; // doctorId or nurseId
  final String providerType; // 'doctor' or 'nurse'
  final DateTime appointmentDateTime;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String? notes;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? location;
  final Map<String, dynamic>? medicalDetails; // For storing medical details after visit

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.providerType,
    required this.appointmentDateTime,
    required this.status,
    this.notes,
    required this.createdAt,
    this.completedAt,
    this.location,
    this.medicalDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'providerType': providerType,
      'appointmentDateTime': appointmentDateTime,
      'status': status,
      'notes': notes,
      'createdAt': createdAt,
      'completedAt': completedAt,
      'location': location,
      'medicalDetails': medicalDetails,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String docId) {
    return AppointmentModel(
      id: docId,
      patientId: map['patientId'] ?? '',
      providerId: map['providerId'] ?? '',
      providerType: map['providerType'] ?? '',
      appointmentDateTime: (map['appointmentDateTime'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null 
          ? (map['completedAt'] as Timestamp).toDate() 
          : null,
      location: map['location'],
      medicalDetails: map['medicalDetails'],
    );
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? providerId,
    String? providerType,
    DateTime? appointmentDateTime,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? completedAt,
    String? location,
    Map<String, dynamic>? medicalDetails,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      providerId: providerId ?? this.providerId,
      providerType: providerType ?? this.providerType,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      location: location ?? this.location,
      medicalDetails: medicalDetails ?? this.medicalDetails,
    );
  }
}
