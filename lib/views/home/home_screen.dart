import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dashboard/patient_dashboard.dart';
import '../dashboard/doctor_dashboard.dart';
import '../dashboard/nurse_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // If no user is logged in, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const SizedBox.shrink();
        }

        // Get user data from Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (userSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${userSnapshot.error}'),
                ),
              );
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              // If user data doesn't exist, redirect to login
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
              return const SizedBox.shrink();
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userType = userData['userType'] as String? ?? 'patient';

            // Return appropriate dashboard based on user type
            switch (userType.toLowerCase()) {
              case 'doctor':
                return DoctorDashboard(userData: userData);
              case 'nurse':
                return NurseDashboard(userData: userData);
              case 'patient':
              default:
                return PatientDashboard(userData: userData);
            }
          },
        );
      },
    );
  }
}
