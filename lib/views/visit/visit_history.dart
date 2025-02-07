import 'package:flutter/material.dart';
import '../../models/user.dart';

class VisitHistoryScreen extends StatelessWidget {
  final User patient;

  VisitHistoryScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit History'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual data
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text('Visit ${index + 1}'),
              subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index * 7)).toString().split(' ')[0]}'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Provider: ${index % 2 == 0 ? 'Dr. Johnson' : 'Nurse Wilson'}'),
                      Text('Type: ${index % 3 == 0 ? 'Regular Checkup' : 'Follow-up'}'),
                      Text('Location: Main Clinic'),
                      SizedBox(height: 8),
                      Text('Vitals:'),
                      Text('• Blood Pressure: 120/80'),
                      Text('• Temperature: 98.6°F'),
                      Text('• Heart Rate: 72 bpm'),
                      SizedBox(height: 8),
                      Text('Notes:'),
                      Text('Patient showing normal progress. No concerns noted.'),
                      if (index % 2 == 0) ...[
                        SizedBox(height: 8),
                        Text('Next Follow-up:'),
                        Text('${DateTime.now().add(Duration(days: 30)).toString().split(' ')[0]}'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 