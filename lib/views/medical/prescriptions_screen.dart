import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base_medical_screen.dart';

class PrescriptionsScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const PrescriptionsScreen({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseMedicalScreen(
      title: 'My Prescriptions',
      userData: userData,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('prescriptions')
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

          final prescriptions = snapshot.data!.docs;

          if (prescriptions.isEmpty) {
            return const Center(
              child: Text('No prescriptions found'),
            );
          }

          return ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = prescriptions[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.medical_services),
                  ),
                  title: Text(prescription['doctorName'] ?? 'Unknown Doctor'),
                  subtitle: Text('Date: ${prescription['date'].toDate().toString()}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Diagnosis: ${prescription['diagnosis']}'),
                          const SizedBox(height: 8),
                          const Text('Medications:'),
                          ...(prescription['medications'] as List<dynamic>).map(
                            (med) => ListTile(
                              title: Text(med['name']),
                              subtitle: Text(
                                'Dosage: ${med['dosage']}\nFrequency: ${med['frequency']}',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Notes: ${prescription['notes'] ?? 'No notes'}'),
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
}
