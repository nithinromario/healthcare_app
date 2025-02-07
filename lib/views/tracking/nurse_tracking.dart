import 'package:flutter/material.dart';
import '../../models/user.dart';

class NurseTrackingScreen extends StatelessWidget {
  final List<User> nurses; // List of nurses under the doctor

  NurseTrackingScreen({required this.nurses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Activity Tracking'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: nurses.length,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
              title: Text(nurses[index].name),
              subtitle: Text('Current Location: City Hospital'),
              children: [
                _buildNurseActivityList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNurseActivityList() {
    return Column(
      children: [
        ListTile(
          title: Text('Today\'s Activities'),
          subtitle: Text('3 visits completed'),
        ),
        Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Patient Visit ${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time: ${9 + index}:00 AM'),
                  Text('Location: 123 Health Street'),
                  Text('Treatment: Administered medication'),
                ],
              ),
              isThreeLine: true,
            );
          },
        ),
      ],
    );
  }
} 