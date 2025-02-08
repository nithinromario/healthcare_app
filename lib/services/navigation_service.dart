import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Auth Routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot_password';

  // Dashboard Routes
  static const String patientDashboard = '/patient_dashboard';
  static const String doctorDashboard = '/doctor_dashboard';
  static const String nurseDashboard = '/nurse_dashboard';

  // Medical Routes
  static const String bookAppointment = '/book_appointment';
  static const String viewAppointments = '/view_appointments';
  static const String medicalHistory = '/medical_history';
  static const String prescriptions = '/prescriptions';
  static const String labReports = '/lab_reports';

  // Profile Routes
  static const String viewProfile = '/view_profile';
  static const String editProfile = '/edit_profile';
  static const String settings = '/settings';

  // Chat Routes
  static const String chatList = '/chat_list';
  static const String chatRoom = '/chat_room';

  // Emergency Routes
  static const String emergency = '/emergency';
  static const String ambulance = '/ambulance';

  static NavigatorState? get _navigator => navigatorKey.currentState;

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigator!.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToReplacement(String routeName, {dynamic arguments}) {
    return _navigator!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToAndRemoveUntil(String routeName, {dynamic arguments}) {
    return _navigator!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static void goBack() {
    _navigator!.pop();
  }

  static bool canGoBack() {
    return _navigator!.canPop();
  }
}
