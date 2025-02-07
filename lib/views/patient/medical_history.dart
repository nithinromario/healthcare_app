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
              Tab(text: 'Treatments'),
              Tab(text: 'Medications'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AppointmentsTab(patient: patient),
            _TreatmentsTab(patient: patient),
            _MedicationsTab(patient: patient),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsTab extends StatelessWidget {
  final User patient;

  _AppointmentsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Appointment ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${DateTime.now().add(Duration(days: index)).toString().split(' ')[0]}'),
                Text('Doctor: Dr. Smith'),
                Text('Status: ${index == 0 ? 'Upcoming' : 'Completed'}'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

class _TreatmentsTab extends StatelessWidget {
  final User patient;

  _TreatmentsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Treatment ${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index * 7)).toString().split(' ')[0]}'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor: Dr. Johnson'),
                    Text('Type: Regular Checkup'),
                    Text('Notes: Patient showing good progress'),
                    Text('Next Follow-up: ${DateTime.now().add(Duration(days: 30)).toString().split(' ')[0]}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MedicationsTab extends StatelessWidget {
  final User patient;

  _MedicationsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.medication),
            title: Text('Medication ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prescribed: ${DateTime.now().subtract(Duration(days: index * 3)).toString().split(' ')[0]}'),
                Text('Duration: ${index + 1} weeks'),
                Text('Dosage: ${index + 1} times daily'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
} 