import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medical_record_detail_screen.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const MedicalHistoryScreen({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  String _selectedType = 'all';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildMedicalRecordsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          _buildFilterChip('Visits', 'visit'),
          _buildFilterChip('Tests', 'test'),
          _buildFilterChip('Medications', 'medication'),
          _buildFilterChip('Injections', 'injection'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: _selectedType == value,
        onSelected: (bool selected) {
          setState(() {
            _selectedType = selected ? value : 'all';
          });
        },
      ),
    );
  }

  Widget _buildMedicalRecordsList() {
    Query query = _firestore
        .collection('medical_records')
        .where('patientId', isEqualTo: widget.userData?['patientId'])
        .orderBy('timestamp', descending: true);

    if (_selectedType != 'all') {
      query = query.where('recordType', isEqualTo: _selectedType);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final records = snapshot.data?.docs ?? [];

        if (records.isEmpty) {
          return const Center(
            child: Text('No medical records found'),
          );
        }

        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index].data() as Map<String, dynamic>;
            final date = (record['timestamp'] as Timestamp).toDate();

            IconData getIcon() {
              switch (record['recordType']) {
                case 'visit':
                  return Icons.medical_services;
                case 'test':
                  return Icons.science;
                case 'medication':
                  return Icons.medication;
                case 'injection':
                  return Icons.healing;
                default:
                  return Icons.article;
              }
            }

            String getTitle() {
              switch (record['recordType']) {
                case 'visit':
                  return 'Medical Visit';
                case 'test':
                  return record['details']['testName'] ?? 'Medical Test';
                case 'medication':
                  return record['details']['medicationName'] ?? 'Medication';
                case 'injection':
                  return record['details']['injectionName'] ?? 'Injection';
                default:
                  return 'Medical Record';
              }
            }

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(
                    getIcon(),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(getTitle()),
                subtitle: Text(
                  '${date.toString().split('.')[0]}\n'
                  'By: ${record['providerType']} at ${record['location']}',
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
}
