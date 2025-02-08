import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'patient_details_screen.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;
  final Map<String, dynamic> appointment;
  final Map<String, dynamic> patientData;

  const AppointmentDetailsScreen({
    Key? key,
    required this.appointmentId,
    required this.appointment,
    required this.patientData,
  }) : super(key: key);

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final dateTime = (widget.appointment['appointmentDateTime'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        actions: [
          if (widget.appointment['status'] == 'pending')
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _confirmAppointment,
            ),
          IconButton(
            icon: const Icon(Icons.medical_services),
            onPressed: () => _addMedicalRecord(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientCard(),
                  const SizedBox(height: 16),
                  _buildAppointmentCard(dateTime),
                  if (widget.appointment['notes'] != null) ...[
                    const SizedBox(height: 16),
                    _buildNotesCard(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPatientCard() {
    return Card(
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
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: const Icon(Icons.person),
              ),
              title: Text(widget.patientData['name'] ?? 'Unknown Patient'),
              subtitle: Text(widget.patientData['email'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailsScreen(
                        patientId: widget.appointment['patientId'],
                        patientData: widget.patientData,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.patientData['phoneNumber'] != null)
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(widget.patientData['phoneNumber']),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(DateTime dateTime) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(
                '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time'),
              subtitle: Text(
                '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Status'),
              subtitle: Text(widget.appointment['status']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.appointment['notes']),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAppointment() async {
    setState(() => _isLoading = true);

    try {
      await _firestore
          .collection('appointments')
          .doc(widget.appointmentId)
          .update({'status': 'confirmed'});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment confirmed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error confirming appointment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addMedicalRecord(BuildContext context) async {
    final TextEditingController diagnosisController = TextEditingController();
    final TextEditingController treatmentController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medical Record'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: diagnosisController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: treatmentController,
                decoration: const InputDecoration(
                  labelText: 'Treatment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
              if (diagnosisController.text.isEmpty || treatmentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in both diagnosis and treatment'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              setState(() => _isLoading = true);
              Navigator.pop(context);

              try {
                await _firestore.collection('medical_records').add({
                  'patientId': widget.appointment['patientId'],
                  'providerId': FirebaseAuth.instance.currentUser!.uid,
                  'providerType': 'doctor',
                  'recordType': 'visit',
                  'timestamp': FieldValue.serverTimestamp(),
                  'details': {
                    'diagnosis': diagnosisController.text,
                    'treatment': treatmentController.text,
                    'notes': notesController.text.isNotEmpty ? notesController.text : null,
                  },
                });

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medical record added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error adding medical record: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
