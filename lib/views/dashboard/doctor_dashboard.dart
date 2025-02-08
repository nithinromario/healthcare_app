import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../medical/appointment_details_screen.dart';
import '../medical/patient_details_screen.dart';
import '../profile/edit_profile_screen.dart';

class DoctorDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DoctorDashboard({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Dashboard' : 
               _selectedIndex == 1 ? 'Appointments' : 
               _selectedIndex == 2 ? 'Patients' : 'Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          _buildAppointments(),
          _buildPatients(),
          _buildProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodayAppointments(),
          const SizedBox(height: 16),
          _buildRecentPatientUpdates(),
        ],
      ),
    );
  }

  Widget _buildTodayAppointments() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('appointments')
          .where('providerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('appointmentDateTime', isGreaterThanOrEqualTo: startOfDay)
          .where('appointmentDateTime', isLessThan: endOfDay)
          .orderBy('appointmentDateTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data?.docs ?? [];

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Appointments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (appointments.isNotEmpty)
                      TextButton(
                        onPressed: () => setState(() => _selectedIndex = 1),
                        child: const Text('View All'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (appointments.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No appointments today'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index].data() as Map<String, dynamic>;
                      final dateTime = (appointment['appointmentDateTime'] as Timestamp).toDate();
                      
                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore
                            .collection('users')
                            .doc(appointment['patientId'])
                            .get(),
                        builder: (context, patientSnapshot) {
                          if (!patientSnapshot.hasData) {
                            return const ListTile(
                              title: Text('Loading...'),
                            );
                          }

                          final patientData = patientSnapshot.data!.data() as Map<String, dynamic>;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              child: const Icon(Icons.person),
                            ),
                            title: Text(patientData['name'] ?? 'Unknown Patient'),
                            subtitle: Text(
                              '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}\n'
                              'Status: ${appointment['status']}',
                            ),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentDetailsScreen(
                                    appointmentId: appointments[index].id,
                                    appointment: appointment,
                                    patientData: patientData,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentPatientUpdates() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('medical_records')
          .where('providerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = snapshot.data?.docs ?? [];

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Patient Updates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (records.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No recent updates'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index].data() as Map<String, dynamic>;
                      final date = (record['timestamp'] as Timestamp).toDate();
                      
                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore
                            .collection('users')
                            .doc(record['patientId'])
                            .get(),
                        builder: (context, patientSnapshot) {
                          if (!patientSnapshot.hasData) {
                            return const ListTile(
                              title: Text('Loading...'),
                            );
                          }

                          final patientData = patientSnapshot.data!.data() as Map<String, dynamic>;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              child: const Icon(Icons.medical_services),
                            ),
                            title: Text(patientData['name'] ?? 'Unknown Patient'),
                            subtitle: Text(
                              '${record['recordType'].toString().toUpperCase()}\n'
                              '${date.toString().split('.')[0]}',
                            ),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientDetailsScreen(
                                    patientId: record['patientId'],
                                    patientData: patientData,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointments() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('appointments')
          .where('providerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', whereIn: ['pending', 'confirmed'])
          .orderBy('appointmentDateTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data?.docs ?? [];

        if (appointments.isEmpty) {
          return const Center(
            child: Text('No upcoming appointments'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index].data() as Map<String, dynamic>;
            final dateTime = (appointment['appointmentDateTime'] as Timestamp).toDate();

            return FutureBuilder<DocumentSnapshot>(
              future: _firestore
                  .collection('users')
                  .doc(appointment['patientId'])
                  .get(),
              builder: (context, patientSnapshot) {
                if (!patientSnapshot.hasData) {
                  return const Card(
                    child: ListTile(
                      title: Text('Loading...'),
                    ),
                  );
                }

                final patientData = patientSnapshot.data!.data() as Map<String, dynamic>;

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.person),
                    ),
                    title: Text(patientData['name'] ?? 'Unknown Patient'),
                    subtitle: Text(
                      '${dateTime.toString().split('.')[0]}\n'
                      'Status: ${appointment['status']}',
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailsScreen(
                            appointmentId: appointments[index].id,
                            appointment: appointment,
                            patientData: patientData,
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
      },
    );
  }

  Widget _buildPatients() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('medical_records')
          .where('providerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
        final patientIds = records
            .map((doc) => (doc.data() as Map<String, dynamic>)['patientId'] as String)
            .toSet()
            .toList();

        if (patientIds.isEmpty) {
          return const Center(
            child: Text('No patients yet'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: patientIds.length,
          itemBuilder: (context, index) {
            return FutureBuilder<DocumentSnapshot>(
              future: _firestore
                  .collection('users')
                  .doc(patientIds[index])
                  .get(),
              builder: (context, patientSnapshot) {
                if (!patientSnapshot.hasData) {
                  return const Card(
                    child: ListTile(
                      title: Text('Loading...'),
                    ),
                  );
                }

                final patientData = patientSnapshot.data!.data() as Map<String, dynamic>;

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.person),
                    ),
                    title: Text(patientData['name'] ?? 'Unknown Patient'),
                    subtitle: Text(patientData['email'] ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientDetailsScreen(
                            patientId: patientIds[index],
                            patientData: patientData,
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
      },
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Name'),
                    subtitle: Text(widget.userData['name'] ?? 'Not provided'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(widget.userData['email'] ?? 'Not provided'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text('Specialization'),
                    subtitle: Text(widget.userData['specialization'] ?? 'Not provided'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone'),
                    subtitle: Text(widget.userData['phoneNumber'] ?? 'Not provided'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            userData: widget.userData,
                          ),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}