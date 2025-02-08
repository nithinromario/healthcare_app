import 'package:flutter/material.dart';
import '../../services/navigation_service.dart';

class BaseMedicalScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Map<String, dynamic> userData;

  const BaseMedicalScreen({
    Key? key,
    required this.title,
    required this.body,
    required this.userData,
    this.actions,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (NavigationService.canGoBack()) {
              NavigationService.goBack();
            } else {
              // If can't go back, return to appropriate dashboard
              final userType = userData['userType']?.toString().toLowerCase() ?? 'patient';
              switch (userType) {
                case 'doctor':
                  NavigationService.navigateToReplacement(NavigationService.doctorDashboard);
                  break;
                case 'nurse':
                  NavigationService.navigateToReplacement(NavigationService.nurseDashboard);
                  break;
                default:
                  NavigationService.navigateToReplacement(NavigationService.patientDashboard);
              }
            }
          },
        ),
        actions: actions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
