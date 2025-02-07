import '../models/treatment.dart';

class TreatmentService {
  static final TreatmentService _instance = TreatmentService._internal();

  factory TreatmentService() {
    return _instance;
  }

  TreatmentService._internal();

  Future<List<Treatment>> getPatientTreatments(String patientId) async {
    // TODO: Replace with actual API call
    return [
      Treatment(
        id: '1',
        patientId: patientId,
        providerId: 'd1',
        type: 'Regular Checkup',
        date: DateTime.now().subtract(Duration(days: 7)),
        diagnosis: 'Healthy',
        medications: ['Vitamin D', 'Iron supplements'],
        notes: 'Patient is showing good progress',
        nextFollowUp: DateTime.now().add(Duration(days: 30)),
      ),
      Treatment(
        id: '2',
        patientId: patientId,
        providerId: 'n1',
        type: 'Blood Test',
        date: DateTime.now().subtract(Duration(days: 14)),
        diagnosis: 'Normal blood count',
        medications: [],
        notes: 'All parameters within normal range',
      ),
    ];
  }

  Future<void> addTreatment(Treatment treatment) async {
    // TODO: Implement API call
    print('Adding treatment: ${treatment.toJson()}');
  }

  Future<void> updateTreatment(Treatment treatment) async {
    // TODO: Implement API call
    print('Updating treatment: ${treatment.toJson()}');
  }
} 