import 'package:flutter/material.dart';
import '../../models/user.dart';

class MedicalHistoryScreen extends StatelessWidget {
  final User patient;

  MedicalHistoryScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medical History'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Appointments'),
              Tab(text: 'Medications'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AppointmentsList(),
            _MedicationsList(),
            _ReportsList(),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Appointment ${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().add(Duration(days: index)).toString().split(' ')[0]}'),
            trailing: Text(index == 0 ? 'Upcoming' : 'Completed'),
          ),
        );
      },
    );
  }
}

class _MedicationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.medication),
            title: Text('Medication ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dosage: 500mg'),
                Text('Frequency: Twice daily'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

class _ReportsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.description),
            title: Text('Report ${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index * 7)).toString().split(' ')[0]}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Show report details
            },
          ),
        );
      },
    );
  }
} 