import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/appointment.dart';
import '../../services/notification_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedType = 'Doctor';
  String selectedProvider = 'Dr. Smith';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(labelText: 'Appointment Type'),
              items: ['Doctor', 'Nurse'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                  selectedProvider = selectedType == 'Doctor' 
                      ? 'Dr. Smith' 
                      : 'Nurse Emma';
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedProvider,
              decoration: InputDecoration(labelText: 'Select Provider'),
              items: selectedType == 'Doctor'
                  ? ['Dr. Smith', 'Dr. Johnson'].map((name) {
                      return DropdownMenuItem(value: name, child: Text(name));
                    }).toList()
                  : ['Nurse Emma', 'Nurse Sarah'].map((name) {
                      return DropdownMenuItem(value: name, child: Text(name));
                    }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvider = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Date: ${selectedDate.toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Time: ${selectedTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                }
              },
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save appointment
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appointment Booked Successfully!')),
                  );
                  Navigator.pop(context);
                },
                child: Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 