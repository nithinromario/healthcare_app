import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base_medical_screen.dart';

class ViewAppointmentsScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ViewAppointmentsScreen({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseMedicalScreen(
      title: 'My Appointments',
      userData: userData,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('patientId', isEqualTo: userData?['id'])
            .orderBy('appointmentDateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data!.docs;

          if (appointments.isEmpty) {
            return const Center(
              child: Text('No appointments found'),
            );
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.calendar_today),
                  ),
                  title: Text(appointment['providerName'] ?? 'Unknown Provider'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${appointment['appointmentDateTime'].toDate().toString()}'),
                      Text('Status: ${appointment['status']}'),
                    ],
                  ),
                  trailing: appointment['status'] == 'pending'
                      ? IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            // TODO: Implement appointment cancellation
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
