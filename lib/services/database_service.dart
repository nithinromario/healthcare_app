import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Appointments
  Future<void> createAppointment({
    required String patientId,
    required String providerId,
    required DateTime dateTime,
    required String type,
    required String status,
    String? notes,
  }) async {
    await _db.collection('appointments').add({
      'patientId': patientId,
      'providerId': providerId,
      'dateTime': dateTime,
      'type': type,
      'status': status,
      'notes': notes,
      'createdAt': DateTime.now(),
    });
  }

  // Medical Records
  Future<void> addMedicalRecord({
    required String patientId,
    required String type,
    required String providerId,
    required Map<String, dynamic> details,
  }) async {
    await _db.collection('medical_records').add({
      'patientId': patientId,
      'type': type, // 'visit', 'medication', 'test', 'injection'
      'providerId': providerId,
      'details': details,
      'timestamp': DateTime.now(),
    });
  }

  // Get Patient's Appointments
  Stream<QuerySnapshot> getPatientAppointments(String patientId) {
    return _db
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  // Get Provider's Appointments
  Stream<QuerySnapshot> getProviderAppointments(String providerId) {
    return _db
        .collection('appointments')
        .where('providerId', isEqualTo: providerId)
        .orderBy('dateTime')
        .snapshots();
  }

  // Get Patient's Medical History
  Stream<QuerySnapshot> getPatientMedicalHistory(String patientId) {
    return _db
        .collection('medical_records')
        .where('patientId', isEqualTo: patientId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Add Medication Record
  Future<void> addMedication({
    required String patientId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required String prescribedBy,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    await _db.collection('medical_records').add({
      'patientId': patientId,
      'type': 'medication',
      'details': {
        'medicationName': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'prescribedBy': prescribedBy,
        'startDate': startDate,
        'endDate': endDate,
        'status': endDate == null ? 'active' : 'completed',
      },
      'timestamp': DateTime.now(),
    });
  }

  // Add Test Result
  Future<void> addTestResult({
    required String patientId,
    required String testName,
    required String orderedBy,
    required String result,
    required String location,
  }) async {
    await _db.collection('medical_records').add({
      'patientId': patientId,
      'type': 'test',
      'details': {
        'testName': testName,
        'orderedBy': orderedBy,
        'result': result,
        'location': location,
      },
      'timestamp': DateTime.now(),
    });
  }

  // Add Visit Record
  Future<void> addVisitRecord({
    required String patientId,
    required String providerId,
    required String visitType,
    required String location,
    required String notes,
    DateTime? followUpDate,
  }) async {
    await _db.collection('medical_records').add({
      'patientId': patientId,
      'type': 'visit',
      'providerId': providerId,
      'details': {
        'visitType': visitType,
        'location': location,
        'notes': notes,
        'followUpDate': followUpDate,
      },
      'timestamp': DateTime.now(),
    });
  }

  // Search Medical Records
  Future<QuerySnapshot> searchMedicalRecords({
    required String patientId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    String? searchTerm,
  }) async {
    Query query = _db.collection('medical_records')
        .where('patientId', isEqualTo: patientId);
    
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    
    if (startDate != null && endDate != null) {
      query = query.where('timestamp', 
        isGreaterThanOrEqualTo: startDate,
        isLessThanOrEqualTo: endDate);
    }
    
    return query.orderBy('timestamp', descending: true).get();
  }

  // Update Appointment Status
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    await _db.collection('appointments')
        .doc(appointmentId)
        .update({'status': status});
  }
} 