import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../medical/medical_record_detail_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String patientId;
  final Map<String, dynamic> patientData;

  const PatientDetailsScreen({
    Key? key,
    required this.patientId,
    required this.patientData,
  }) : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedRecordType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientData['name'] ?? 'Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.medical_services),
            onPressed: () => _addMedicalRecord(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPatientInfo(),
          _buildRecordTypeFilter(),
          Expanded(
            child: _buildMedicalRecords(),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name'),
              subtitle: Text(widget.patientData['name'] ?? 'Not provided'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(widget.patientData['email'] ?? 'Not provided'),
            ),
            if (widget.patientData['phoneNumber'] != null)
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: Text(widget.patientData['phoneNumber']),
              ),
            if (widget.patientData['address'] != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Address'),
                subtitle: Text(widget.patientData['address']),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTypeFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Visits', 'visit'),
          const SizedBox(width: 8),
          _buildFilterChip('Tests', 'test'),
          const SizedBox(width: 8),
          _buildFilterChip('Medications', 'medication'),
          const SizedBox(width: 8),
          _buildFilterChip('Injections', 'injection'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedRecordType == value,
      onSelected: (bool selected) {
        setState(() {
          _selectedRecordType = value;
        });
      },
    );
  }

  Widget _buildMedicalRecords() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('medical_records')
          .where('patientId', isEqualTo: widget.patientId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final records = snapshot.data?.docs ?? [];
        final filteredRecords = _selectedRecordType == 'all'
            ? records
            : records.where((doc) =>
                (doc.data() as Map<String, dynamic>)['recordType'] == _selectedRecordType).toList();

        if (filteredRecords.isEmpty) {
          return const Center(
            child: Text('No medical records found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: filteredRecords.length,
          itemBuilder: (context, index) {
            final record = filteredRecords[index].data() as Map<String, dynamic>;
            final date = (record['timestamp'] as Timestamp).toDate();

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(_getRecordTypeIcon(record['recordType'])),
                ),
                title: Text(
                  record['recordType'].toString().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${date.toString().split('.')[0]}\n'
                  'Provider: ${record['providerType'].toString().toUpperCase()}',
                ),
                isThreeLine: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicalRecordDetailScreen(
                        record: record,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  IconData _getRecordTypeIcon(String recordType) {
    switch (recordType) {
      case 'visit':
        return Icons.medical_services;
      case 'test':
        return Icons.science;
      case 'medication':
        return Icons.medication;
      case 'injection':
        return Icons.vaccines;
      default:
        return Icons.medical_services;
    }
  }

  Future<void> _addMedicalRecord(BuildContext context) async {
    String recordType = 'visit';
    final TextEditingController detailsController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Medical Record'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: recordType,
                  decoration: const InputDecoration(
                    labelText: 'Record Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'visit', child: Text('Visit')),
                    DropdownMenuItem(value: 'test', child: Text('Test')),
                    DropdownMenuItem(value: 'medication', child: Text('Medication')),
                    DropdownMenuItem(value: 'injection', child: Text('Injection')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => recordType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    labelText: _getDetailsLabel(recordType),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (detailsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in the details'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.pop(context);

                try {
                  final details = <String, dynamic>{};
                  
                  switch (recordType) {
                    case 'visit':
                      details['diagnosis'] = detailsController.text;
                      break;
                    case 'test':
                      details['testName'] = detailsController.text;
                      break;
                    case 'medication':
                      details['medicationName'] = detailsController.text;
                      break;
                    case 'injection':
                      details['injectionName'] = detailsController.text;
                      break;
                  }

                  if (notesController.text.isNotEmpty) {
                    details['notes'] = notesController.text;
                  }

                  await _firestore.collection('medical_records').add({
                    'patientId': widget.patientId,
                    'providerId': FirebaseAuth.instance.currentUser!.uid,
                    'providerType': 'doctor',
                    'recordType': recordType,
                    'timestamp': FieldValue.serverTimestamp(),
                    'details': details,
                  });

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Medical record added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adding medical record: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDetailsLabel(String recordType) {
    switch (recordType) {
      case 'visit':
        return 'Diagnosis';
      case 'test':
        return 'Test Name';
      case 'medication':
        return 'Medication Name';
      case 'injection':
        return 'Injection Name';
      default:
        return 'Details';
    }
  }
}
