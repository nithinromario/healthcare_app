import 'package:flutter/material.dart';
import '../../models/medical_record.dart';
import '../../models/user.dart';
import '../../services/notification_service.dart';

class RecordVisitScreen extends StatefulWidget {
  final User provider;
  final String patientId;

  RecordVisitScreen({
    required this.provider,
    required this.patientId,
  });

  @override
  _RecordVisitScreenState createState() => _RecordVisitScreenState();
}

class _RecordVisitScreenState extends State<RecordVisitScreen> {
  final List<Treatment> treatments = [];
  String notes = '';
  String location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Visit Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => location = value,
            ),
            SizedBox(height: 16),
            Text(
              'Treatments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: treatments.length,
              itemBuilder: (context, index) {
                final treatment = treatments[index];
                return Card(
                  child: ListTile(
                    title: Text(treatment.name),
                    subtitle: Text('${treatment.type} - ${treatment.dosage}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          treatments.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTreatment,
              child: Text('Add Treatment'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => notes = value,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveVisitRecord,
                child: Text('Save Visit Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTreatment() {
    showDialog(
      context: context,
      builder: (context) => _TreatmentDialog(),
    ).then((treatment) {
      if (treatment != null) {
        setState(() {
          treatments.add(treatment);
        });
      }
    });
  }

  void _saveVisitRecord() async {
    if (location.isEmpty || treatments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Notify patient about the completed visit
    await NotificationService().showVisitNotification(
      title: 'Visit Completed',
      body: 'Your healthcare provider has updated your medical record',
    );

    // For medications/injections, set reminders if needed
    for (var treatment in treatments) {
      if (treatment.type == 'medication') {
        await NotificationService().showMedicationReminder(
          title: 'Medication Reminder',
          body: 'Time to take ${treatment.name} - ${treatment.dosage}',
          scheduledDate: DateTime.now().add(Duration(hours: 6)), // Adjust timing as needed
        );
      }
    }

    // TODO: Implement save logic

    Navigator.pop(context);
  }
}

class _TreatmentDialog extends StatefulWidget {
  @override
  _TreatmentDialogState createState() => _TreatmentDialogState();
}

class _TreatmentDialogState extends State<_TreatmentDialog> {
  String type = 'medication';
  String name = '';
  String dosage = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Treatment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: type,
            items: ['medication', 'injection'].map((t) {
              return DropdownMenuItem(
                value: t,
                child: Text(t.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => type = value!);
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (value) => name = value,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Dosage'),
            onChanged: (value) => dosage = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (name.isEmpty || dosage.isEmpty) return;
            
            Navigator.pop(
              context,
              Treatment(
                type: type,
                name: name,
                dosage: dosage,
                administeredAt: DateTime.now(),
                administeredBy: 'Current Provider', // Replace with actual provider
                location: 'Current Location', // Replace with actual location
              ),
            );
          },
          child: Text('Add'),
        ),
      ],
    );
  }
} 