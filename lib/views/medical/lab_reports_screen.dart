import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base_medical_screen.dart';

class LabReportsScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const LabReportsScreen({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseMedicalScreen(
      title: 'Lab Reports',
      userData: userData,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lab_reports')
            .where('patientId', isEqualTo: userData?['id'])
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!.docs;

          if (reports.isEmpty) {
            return const Center(
              child: Text('No lab reports found'),
            );
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index].data() as Map<String, dynamic>;
              final date = (report['date'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(report['testName'] ?? 'Unknown Test'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${_formatDate(date)}'),
                      Text('Lab: ${report['labName'] ?? 'Unknown Lab'}'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Doctor: ${report['doctorName'] ?? 'Not specified'}'),
                          const SizedBox(height: 8),
                          const Text('Results:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          ...(report['results'] as List<dynamic>).map(
                            (result) => ListTile(
                              title: Text(result['parameter']),
                              subtitle: Text(
                                'Value: ${result['value']}\nReference Range: ${result['referenceRange']}',
                              ),
                              trailing: Icon(
                                _getStatusIcon(result['status']),
                                color: _getStatusColor(result['status']),
                              ),
                            ),
                          ),
                          if (report['notes'] != null) ...[
                            const SizedBox(height: 8),
                            Text('Notes: ${report['notes']}'),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Icons.check_circle;
      case 'high':
        return Icons.arrow_upward;
      case 'low':
        return Icons.arrow_downward;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Colors.green;
      case 'high':
      case 'low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
