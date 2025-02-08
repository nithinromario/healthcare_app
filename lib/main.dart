import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/dashboard/patient_dashboard.dart';
import 'views/dashboard/doctor_dashboard.dart';
import 'views/dashboard/nurse_dashboard.dart';
import 'services/auth_service.dart';
import 'views/auth/auth_wrapper.dart';
import 'views/medical/book_appointment_screen.dart';
import 'views/medical/view_appointments_screen.dart';
import 'views/medical/medical_history_screen.dart';
import 'views/medical/prescriptions_screen.dart';
import 'views/medical/lab_reports_screen.dart';
import 'views/profile/view_profile_screen.dart';
import 'views/profile/edit_profile_screen.dart';
import 'views/profile/settings_screen.dart';
import 'views/chat/chat_list_screen.dart';
import 'views/chat/chat_room_screen.dart';
import 'views/emergency/emergency_screen.dart';
import 'views/emergency/ambulance_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable offline persistence
  await FirebaseFirestore.instance.enablePersistence();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare App',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        // Auth Routes
        '/': (context) => const AuthWrapper(),
        NavigationService.login: (context) => const LoginScreen(),
        NavigationService.signup: (context) => const SignupScreen(),
        NavigationService.forgotPassword: (context) => const ForgotPasswordScreen(),

        // Dashboard Routes
        NavigationService.patientDashboard: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return PatientDashboard(userData: args ?? {});
        },
        NavigationService.doctorDashboard: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return DoctorDashboard(userData: args ?? {});
        },
        NavigationService.nurseDashboard: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return NurseDashboard(userData: args ?? {});
        },

        // Medical Routes
        NavigationService.bookAppointment: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return BookAppointmentScreen(userData: args ?? {});
        },
        NavigationService.viewAppointments: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ViewAppointmentsScreen(userData: args ?? {});
        },
        NavigationService.medicalHistory: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return MedicalHistoryScreen(userData: args ?? {});
        },
        NavigationService.prescriptions: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return PrescriptionsScreen(userData: args ?? {});
        },
        NavigationService.labReports: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return LabReportsScreen(userData: args ?? {});
        },

        // Profile Routes
        NavigationService.viewProfile: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ViewProfileScreen(userData: args ?? {});
        },
        NavigationService.editProfile: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return EditProfileScreen(userData: args ?? {});
        },
        NavigationService.settings: (context) => const SettingsScreen(),

        // Chat Routes
        NavigationService.chatList: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ChatListScreen(userData: args ?? {});
        },
        NavigationService.chatRoom: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ChatRoomScreen(chatData: args ?? {});
        },

        // Emergency Routes
        NavigationService.emergency: (context) => const EmergencyScreen(),
        NavigationService.ambulance: (context) => const AmbulanceScreen(),
      },
    );
  }
}

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

        // Get user data from Firestore with offline support
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .get(const GetOptions(source: Source.cache)),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              // If no data exists, create a basic profile
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