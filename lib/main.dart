import 'package:flutter/material.dart';
import 'views/auth/login_screen.dart';
import 'views/dashboard/patient_dashboard.dart';
import 'views/dashboard/doctor_dashboard.dart';
import 'views/dashboard/nurse_dashboard.dart';
import 'views/appointment/book_appointment.dart';
import 'views/patient/medical_history.dart';
import 'views/patient/detailed_medical_history.dart';

void main() {
  runApp(HealthcareApp());
}

class HealthcareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/patient_dashboard': (context) => PatientDashboard(),
        '/doctor_dashboard': (context) => DoctorDashboard(),
        '/nurse_dashboard': (context) => NurseDashboard(),
        '/book_appointment': (context) => BookAppointmentScreen(),
        '/medical_history': (context) => MedicalHistoryScreen(),
        '/detailed_history': (context) => DetailedMedicalHistoryScreen(),
        // Add more routes for other screens
      },
    );
  }
}
