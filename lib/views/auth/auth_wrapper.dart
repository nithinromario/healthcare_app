import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import '../dashboard/patient_dashboard.dart';
import '../dashboard/doctor_dashboard.dart';
import '../dashboard/nurse_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

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
          return const LoginScreen();
        }

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

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              final basicUserData = {
                'email': snapshot.data!.email,
                'userType': 'patient',
                'createdAt': FieldValue.serverTimestamp(),
              };

              FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .set(basicUserData, SetOptions(merge: true));

              return PatientDashboard(userData: basicUserData);
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userType = userData['userType'] as String? ?? 'patient';

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
