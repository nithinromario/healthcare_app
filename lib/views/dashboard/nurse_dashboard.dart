import 'package:flutter/material.dart';

class NurseDashboard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const NurseDashboard({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome Nurse ${userData['name']}'),
      ),
    );
  }
} 