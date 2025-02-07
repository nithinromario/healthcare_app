class Treatment {
  final String id;
  final String patientId;
  final String providerId; // doctor or nurse ID
  final String type; // 'checkup', 'procedure', 'test', etc.
  final DateTime date;
  final String diagnosis;
  final List<String> medications;
  final String notes;
  final DateTime? nextFollowUp;

  Treatment({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.type,
    required this.date,
    required this.diagnosis,
    required this.medications,
    required this.notes,
    this.nextFollowUp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'type': type,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'medications': medications,
      'notes': notes,
      'nextFollowUp': nextFollowUp?.toIso8601String(),
    };
  }

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      patientId: json['patientId'],
      providerId: json['providerId'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      diagnosis: json['diagnosis'],
      medications: List<String>.from(json['medications']),
      notes: json['notes'],
      nextFollowUp: json['nextFollowUp'] != null 
          ? DateTime.parse(json['nextFollowUp']) 
          : null,
    );
  }
} 