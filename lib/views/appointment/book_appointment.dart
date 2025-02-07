import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/appointment.dart';
import '../../services/notification_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  final User patient;
  final String providerType; // "doctor" or "nurse"

  BookAppointmentScreen({
    required this.patient,
    required this.providerType,
  });

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedLocation;
  String notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.providerType} Appointment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(selectedDate != null 
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : 'Select Date'),
                onTap: _selectDate,
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.access_time),
                title: Text(selectedTime != null 
                  ? '${selectedTime!.format(context)}'
                  : 'Select Time'),
                onTap: _selectTime,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => selectedLocation = value,
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
                onPressed: _bookAppointment,
                child: Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _bookAppointment() async {
    if (selectedDate == null || selectedTime == null || selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Schedule appointment notification
    await NotificationService().showAppointmentNotification(
      title: 'Upcoming Appointment',
      body: 'You have an appointment tomorrow at ${selectedTime!.format(context)}',
      scheduledDate: selectedDate!.subtract(Duration(days: 1)),
    );

    // TODO: Implement appointment booking logic
    
    Navigator.pop(context);
  }
} 