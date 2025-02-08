import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecordDetailScreen extends StatelessWidget {
  final Map<String, dynamic> record;

  const MedicalRecordDetailScreen({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = (record['timestamp'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    _buildInfoRow('Date', date.toString().split('.')[0]),
                    _buildInfoRow('Type', record['recordType'].toString().toUpperCase()),
                    _buildInfoRow('Provider Type', record['providerType']),
                    _buildInfoRow('Location', record['location']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    _buildDetailsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList() {
    final details = record['details'] as Map<String, dynamic>;

    switch (record['recordType']) {
      case 'visit':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Diagnosis', details['diagnosis'] ?? ''),
            _buildInfoRow('Treatment', details['treatment'] ?? ''),
            if (details['notes'] != null)
              _buildInfoRow('Notes', details['notes']),
          ],
        );

      case 'medication':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Medication', details['medicationName'] ?? ''),
            _buildInfoRow('Dosage', details['dosage'] ?? ''),
            _buildInfoRow('Frequency', details['frequency'] ?? ''),
            _buildInfoRow(
              'Start Date',
              (details['startDate'] as Timestamp).toDate().toString().split('.')[0],
            ),
            if (details['endDate'] != null)
              _buildInfoRow(
                'End Date',
                (details['endDate'] as Timestamp).toDate().toString().split('.')[0],
              ),
            if (details['notes'] != null)
              _buildInfoRow('Notes', details['notes']),
          ],
        );

      case 'injection':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Injection', details['injectionName'] ?? ''),
            _buildInfoRow('Dosage', details['dosage'] ?? ''),
            if (details['notes'] != null)
              _buildInfoRow('Notes', details['notes']),
          ],
        );

      case 'test':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Test Name', details['testName'] ?? ''),
            _buildInfoRow('Result', details['result'] ?? ''),
            if (details['notes'] != null)
              _buildInfoRow('Notes', details['notes']),
          ],
        );

      default:
        return const Text('No details available');
    }
  }

  String getTitle() {
    switch (record['recordType']) {
      case 'visit':
        return 'Visit Details';
      case 'test':
        return 'Test Results';
      case 'medication':
        return 'Medication Details';
      case 'injection':
        return 'Injection Details';
      default:
        return 'Medical Record';
    }
  }
}
