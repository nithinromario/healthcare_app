import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/navigation_service.dart';
import '../medical/book_appointment_screen.dart';
import '../medical/medical_history_screen.dart';
import '../profile/edit_profile_screen.dart';

class PatientDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PatientDashboard({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildNavigationGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavigationService.navigateTo(
          NavigationService.bookAppointment,
          arguments: widget.userData,
        ),
        child: const Icon(Icons.add),
        tooltip: 'Book Appointment',
      ),
    );
  }

  Widget _buildNavigationGrid() {
    final List<Map<String, dynamic>> navigationItems = [
      {
        'title': 'Book Appointment',
        'icon': Icons.calendar_today,
        'route': NavigationService.bookAppointment,
      },
      {
        'title': 'My Appointments',
        'icon': Icons.schedule,
        'route': NavigationService.viewAppointments,
      },
      {
        'title': 'Medical History',
        'icon': Icons.history,
        'route': NavigationService.medicalHistory,
      },
      {
        'title': 'Prescriptions',
        'icon': Icons.receipt,
        'route': NavigationService.prescriptions,
      },
      {
        'title': 'Lab Reports',
        'icon': Icons.science,
        'route': NavigationService.labReports,
      },
      {
        'title': 'Chat with Doctor',
        'icon': Icons.chat,
        'route': NavigationService.chatList,
      },
      {
        'title': 'Emergency',
        'icon': Icons.emergency,
        'route': NavigationService.emergency,
      },
      {
        'title': 'Profile',
        'icon': Icons.person,
        'route': NavigationService.viewProfile,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: navigationItems.length,
      itemBuilder: (context, index) {
        final item = navigationItems[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => NavigationService.navigateTo(
              item['route'],
              arguments: widget.userData,
            ),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'],
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Patient Dashboard'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => NavigationService.navigateTo(NavigationService.settings),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (mounted) {
              NavigationService.navigateToAndRemoveUntil(NavigationService.login);
            }
          },
        ),
      ],
    );
  }
}