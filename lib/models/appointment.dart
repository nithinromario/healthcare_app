class Appointment {
  final String id;
  final String patientId;
  final String providerId; // doctor or nurse id
  final DateTime appointmentTime;
  final String location;
  final bool isConfirmed;
  final DateTime? actualVisitTime;
  final String status; // pending, confirmed, completed, cancelled

  Appointment({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.appointmentTime,
    required this.location,
    this.isConfirmed = false,
    this.actualVisitTime,
    this.status = 'pending',
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      providerId: json['providerId'],
      appointmentTime: DateTime.parse(json['appointmentTime']),
      location: json['location'],
      isConfirmed: json['isConfirmed'],
      actualVisitTime: json['actualVisitTime'] != null 
          ? DateTime.parse(json['actualVisitTime'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'appointmentTime': appointmentTime.toIso8601String(),
      'location': location,
      'isConfirmed': isConfirmed,
      'actualVisitTime': actualVisitTime?.toIso8601String(),
      'status': status,
    };
  }
} 