import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/appointment.dart';

class DoctorDashboard extends StatefulWidget {
  final User user;

  DoctorDashboard({required this.user});

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Nurse Tasks',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildAppointmentsTab();
      case 1:
        return _buildPatientsTab();
      case 2:
        return _buildNurseTasksTab();
      default:
        return _buildAppointmentsTab();
    }
  }

  Widget _buildAppointmentsTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Appointments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with actual appointments
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('P${index + 1}'),
                    ),
                    title: Text('Patient Name ${index + 1}'),
                    subtitle: Text('Time: ${9 + index}:00 AM'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_circle_outline),
                          onPressed: () {
                            // Confirm appointment
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.medical_information),
                          onPressed: () {
                            // View/Update medical records
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual patient list
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('P${index + 1}'),
                    ),
                    title: Text('Patient Name ${index + 1}'),
                    subtitle: Text('Last Visit: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
                    onTap: () {
                      // Navigate to patient details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNurseTasksTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nurse Activities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with actual nurse tasks
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text('Nurse ${index + 1}'),
                    subtitle: Text('Active Tasks: ${index + 2}'),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: index + 2,
                        itemBuilder: (context, taskIndex) {
                          return ListTile(
                            leading: Icon(Icons.medical_services),
                            title: Text('Patient Visit ${taskIndex + 1}'),
                            subtitle: Text('Status: Completed'),
                            trailing: Icon(Icons.check_circle, color: Colors.green),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 