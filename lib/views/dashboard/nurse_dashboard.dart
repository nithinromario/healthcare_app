import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/appointment.dart';

class NurseDashboard extends StatefulWidget {
  final User user;

  NurseDashboard({required this.user});

  @override
  _NurseDashboardState createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Dashboard'),
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
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildTasksTab();
      case 1:
        return _buildHistoryTab();
      case 2:
        return _buildLocationTab();
      default:
        return _buildTasksTab();
    }
  }

  Widget _buildTasksTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Tasks',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with actual tasks
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.medical_services, color: Colors.white),
                    ),
                    title: Text('Patient Visit ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Time: ${9 + index}:00 AM'),
                        Text('Location: 123 Health Street'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Start Visit'),
                          value: 'start',
                        ),
                        PopupMenuItem(
                          child: Text('Complete Visit'),
                          value: 'complete',
                        ),
                        PopupMenuItem(
                          child: Text('Add Medical Record'),
                          value: 'record',
                        ),
                      ],
                      onSelected: (value) {
                        // Handle menu selection
                        switch (value) {
                          case 'start':
                            _startVisit(index);
                            break;
                          case 'complete':
                            _completeVisit(index);
                            break;
                          case 'record':
                            _addMedicalRecord(index);
                            break;
                        }
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit History',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Patient Visit ${index + 1}'),
                    subtitle: Text('Completed on: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                    onTap: () {
                      // View visit details
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

  Widget _buildLocationTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, size: 48, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Current Location',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text('123 Health Street'),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Update location
            },
            child: Text('Update Location'),
          ),
        ],
      ),
    );
  }

  void _startVisit(int index) {
    // Implement visit start logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start Visit'),
        content: Text('Are you sure you want to start this visit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update visit status
              Navigator.pop(context);
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }

  void _completeVisit(int index) {
    // Implement visit completion logic
  }

  void _addMedicalRecord(int index) {
    // Navigate to medical record form
  }
} 