import 'package:flutter/material.dart';
import '../../models/treatment.dart';
import '../../models/user.dart';

class AddTreatmentScreen extends StatefulWidget {
  final User patient;
  final User provider;

  AddTreatmentScreen({
    required this.patient,
    required this.provider,
  });

  @override
  _AddTreatmentScreenState createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String type = 'Regular Checkup';
  String diagnosis = '';
  List<String> medications = [];
  String notes = '';
  DateTime? nextFollowUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Treatment'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: type,
              decoration: InputDecoration(labelText: 'Treatment Type'),
              items: [
                'Regular Checkup',
                'Blood Test',
                'Procedure',
                'Surgery',
                'Vaccination'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Diagnosis'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter diagnosis';
                }
                return null;
              },
              onSaved: (value) {
                diagnosis = value!;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Notes'),
              maxLines: 3,
              onSaved: (value) {
                notes = value ?? '';
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Next Follow-up'),
              subtitle: Text(nextFollowUp?.toString() ?? 'Not scheduled'),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      nextFollowUp = date;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTreatment,
        child: Icon(Icons.save),
      ),
    );
  }

  void _saveTreatment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final treatment = Treatment(
        id: DateTime.now().toString(), // Replace with proper ID generation
        patientId: widget.patient.id,
        providerId: widget.provider.id,
        type: type,
        date: DateTime.now(),
        diagnosis: diagnosis,
        medications: medications,
        notes: notes,
        nextFollowUp: nextFollowUp,
      );

      // TODO: Save treatment using TreatmentService
      Navigator.pop(context);
    }
  }
} 