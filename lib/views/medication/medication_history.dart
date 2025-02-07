import 'package:flutter/material.dart';
import '../../models/medication.dart';
import '../../models/user.dart';

class MedicationHistoryScreen extends StatelessWidget {
  final User patient;

  MedicationHistoryScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medication History'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MedicationList(isActive: true, patient: patient),
            _MedicationList(isActive: false, patient: patient),
          ],
        ),
      ),
    );
  }
}

class _MedicationList extends StatelessWidget {
  final bool isActive;
  final User patient;

  _MedicationList({required this.isActive, required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Medication ${index + 1}'),
            subtitle: Text(isActive ? 'Current' : 'Completed'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dosage: 500mg'),
                    Text('Frequency: Twice daily'),
                    Text('Started: ${DateTime.now().subtract(Duration(days: 30)).toString().split(' ')[0]}'),
                    if (!isActive)
                      Text('Ended: ${DateTime.now().toString().split(' ')[0]}'),
                    Text('Prescribed by: Dr. Smith'),
                    Text('Notes: Take after meals'),
                    SizedBox(height: 8),
                    Text('Side Effects:'),
                    Text('• Drowsiness\n• Nausea'),
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