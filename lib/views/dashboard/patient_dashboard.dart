import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/appointment.dart';
import '../../views/patient/medical_history.dart';

class PatientDashboard extends StatefulWidget {
  final User user;

  PatientDashboard({required this.user});

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicalHistoryScreen(patient: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildAppointmentsTab();
      case 2:
        return _buildHistoryTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.user.name}!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.medical_services),
              title: Text('Book Doctor Appointment'),
              onTap: () {
                // Navigate to doctor booking
              },
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.healing),
              title: Text('Book Nurse Visit'),
              onTap: () {
                // Navigate to nurse booking
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Upcoming Appointments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          // TODO: Add upcoming appointments list
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return Center(
      child: Text('Appointments Tab'),
    );
  }
  Widget _buildHistoryTab() {
    return Center(
      child: Text('Medical History Tab'),
    );
  }
} 