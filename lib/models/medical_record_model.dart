import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecordModel {
  final String id;
  final String patientId;
  final String providerId; // doctorId or nurseId
  final String providerType; // 'doctor' or 'nurse'
  final String recordType; // 'visit', 'test', 'medication', 'injection'
  final DateTime timestamp;
  final String location;
  final Map<String, dynamic> details;

  MedicalRecordModel({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.providerType,
    required this.recordType,
    required this.timestamp,
    required this.location,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'providerType': providerType,
      'recordType': recordType,
      'timestamp': timestamp,
      'location': location,
      'details': details,
    };
  }

  factory MedicalRecordModel.fromMap(Map<String, dynamic> map, String docId) {
    return MedicalRecordModel(
      id: docId,
      patientId: map['patientId'] ?? '',
      providerId: map['providerId'] ?? '',
      providerType: map['providerType'] ?? '',
      recordType: map['recordType'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      location: map['location'] ?? '',
      details: Map<String, dynamic>.from(map['details'] ?? {}),
    );
  }

  // Helper method to create a visit record
  factory MedicalRecordModel.createVisit({
    required String id,
    required String patientId,
    required String providerId,
    required String providerType,
    required String location,
    required String diagnosis,
    required String treatment,
    String? notes,
  }) {
    return MedicalRecordModel(
      id: id,
      patientId: patientId,
      providerId: providerId,
      providerType: providerType,
      recordType: 'visit',
      timestamp: DateTime.now(),
      location: location,
      details: {
        'diagnosis': diagnosis,
        'treatment': treatment,
        'notes': notes,
      },
    );
  }

  // Helper method to create a medication record
  factory MedicalRecordModel.createMedication({
    required String id,
    required String patientId,
    required String providerId,
    required String providerType,
    required String location,
    required String medicationName,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) {
    return MedicalRecordModel(
      id: id,
      patientId: patientId,
      providerId: providerId,
      providerType: providerType,
      recordType: 'medication',
      timestamp: DateTime.now(),
      location: location,
      details: {
        'medicationName': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'startDate': startDate,
        'endDate': endDate,
        'notes': notes,
      },
    );
  }

  // Helper method to create an injection record
  factory MedicalRecordModel.createInjection({
    required String id,
    required String patientId,
    required String providerId,
    required String providerType,
    required String location,
    required String injectionName,
    required String dosage,
    String? notes,
  }) {
    return MedicalRecordModel(
      id: id,
      patientId: patientId,
      providerId: providerId,
      providerType: providerType,
      recordType: 'injection',
      timestamp: DateTime.now(),
      location: location,
      details: {
        'injectionName': injectionName,
        'dosage': dosage,
        'notes': notes,
      },
    );
  }

  // Helper method to create a test record
  factory MedicalRecordModel.createTest({
    required String id,
    required String patientId,
    required String providerId,
    required String providerType,
    required String location,
    required String testName,
    required String result,
    String? notes,
  }) {
    return MedicalRecordModel(
      id: id,
      patientId: patientId,
      providerId: providerId,
      providerType: providerType,
      recordType: 'test',
      timestamp: DateTime.now(),
      location: location,
      details: {
        'testName': testName,
        'result': result,
        'notes': notes,
      },
    );
  }
}
