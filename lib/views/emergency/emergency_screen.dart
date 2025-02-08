import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/navigation_service.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmergencyButton(
              icon: Icons.local_hospital,
              title: 'Call Emergency Services (108)',
              onPressed: () => _makePhoneCall('108'),
            ),
            const SizedBox(height: 16),
            _buildEmergencyButton(
              icon: Icons.local_taxi,
              title: 'Request Ambulance',
              onPressed: () => NavigationService.navigateTo(NavigationService.ambulance),
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            const Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildEmergencyContactList(),
            const SizedBox(height: 24),
            const Text(
              'First Aid Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFirstAidTips(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add emergency contact
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmergencyButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    Color color = Colors.red,
  }) {
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactList() {
    final contacts = [
      {'name': 'Dr. John Smith', 'role': 'Primary Doctor', 'phone': '555-0123'},
      {'name': 'City Hospital', 'role': 'Emergency Room', 'phone': '555-0124'},
      {'name': 'Jane Doe', 'role': 'Emergency Contact', 'phone': '555-0125'},
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(contact['name']!),
            subtitle: Text(contact['role']!),
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () => _makePhoneCall(contact['phone']!),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFirstAidTips() {
    final tips = [
      {
        'title': 'Chest Pain',
        'description': 'Call emergency services immediately. Have the person sit down and rest.',
      },
      {
        'title': 'Severe Bleeding',
        'description': 'Apply direct pressure to the wound. Elevate the injured area if possible.',
      },
      {
        'title': 'Choking',
        'description': 'Perform the Heimlich maneuver. Call emergency services if unsuccessful.',
      },
      {
        'title': 'Burns',
        'description': 'Cool the burn under cold running water for at least 10 minutes.',
      },
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return ExpansionTile(
            leading: const Icon(Icons.medical_services),
            title: Text(tip['title']!),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(tip['description']!),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}
