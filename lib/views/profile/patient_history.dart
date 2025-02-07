import 'package:flutter/material.dart';
import '../../models/medical_record.dart';
import '../../models/user.dart';

class PatientHistoryScreen extends StatelessWidget {
  final User patient;

  PatientHistoryScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medical History'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Visits'),
              Tab(text: 'Medications'),
              Tab(text: 'Tests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _VisitsTab(patient: patient),
            _MedicationsTab(patient: patient),
            _TestsTab(patient: patient),
          ],
        ),
      ),
    );
  }
}

class _VisitsTab extends StatelessWidget {
  final User patient;

  _VisitsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 10, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          child: ExpansionTile(
            title: Text('Visit on ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
            subtitle: Text('Provider: Dr. Smith'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location: 123 Medical Center'),
                    SizedBox(height: 8),
                    Text('Treatments:'),
                    ListTile(
                      leading: Icon(Icons.medical_services),
                      title: Text('Medication A'),
                      subtitle: Text('Dosage: 10mg'),
                    ),
                    Text('Notes: Regular checkup completed'),
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
      padding: EdgeInsets.all(16),
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.medication),
            title: Text('Medication ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Administered by: Nurse Johnson'),
                Text('Date: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
                Text('Location: Home Visit'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

class _TestsTab extends StatelessWidget {
  final User patient;

  _TestsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 3, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.science),
            title: Text('Test ${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index * 7)).toString().split(' ')[0]}'),
            trailing: IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {
                // Download test results
              },
            ),
          ),
        );
      },
    );
  }
} 