class MedicalRecord {
  final String id;
  final String patientId;
  final String providerId; // doctor or nurse id
  final String providerType; // "doctor" or "nurse"
  final DateTime visitDateTime;
  final String location;
  final List<Treatment> treatments;
  final String notes;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.providerType,
    required this.visitDateTime,
    required this.location,
    required this.treatments,
    required this.notes,
  });
}

class Treatment {
  final String type; // "medication" or "injection"
  final String name;
  final String dosage;
  final DateTime administeredAt;
  final String administeredBy;
  final String location;

  Treatment({
    required this.type,
    required this.name,
    required this.dosage,
    required this.administeredAt,
    required this.administeredBy,
    required this.location,
  });
} 