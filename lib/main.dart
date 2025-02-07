import 'package:flutter/material.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';

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
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}
