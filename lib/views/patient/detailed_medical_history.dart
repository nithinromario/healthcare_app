import 'package:flutter/material.dart';

class DetailedMedicalHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medical History'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Visits'),
              Tab(text: 'Medications'),
              Tab(text: 'Tests'),
              Tab(text: 'Injections'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _VisitHistoryTab(),
            _MedicationHistoryTab(),
            _TestHistoryTab(),
            _InjectionHistoryTab(),
          ],
        ),
      ),
    );
  }
}

class _VisitHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Visit on ${DateTime.now().subtract(Duration(days: index * 7)).toString().split(' ')[0]}'),
            subtitle: Text(index % 2 == 0 ? 'Doctor Visit' : 'Nurse Visit'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provider: ${index % 2 == 0 ? 'Dr. Smith' : 'Nurse Emma'}'),
                    Text('Time: 10:30 AM'),
                    Text('Location: Home Visit'),
                    Text('Notes: Regular checkup, vitals normal'),
                    Text('Next Visit: ${DateTime.now().add(Duration(days: 30)).toString().split(' ')[0]}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MedicationHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Medication ${index + 1}'),
            subtitle: Text('Started: ${DateTime.now().subtract(Duration(days: index * 10)).toString().split(' ')[0]}'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: Medicine ${index + 1}'),
                    Text('Dosage: ${(index + 1) * 250}mg'),
                    Text('Frequency: ${index + 2}x daily'),
                    Text('Prescribed by: Dr. Johnson'),
                    Text('Duration: ${(index + 1) * 7} days'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TestHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Test ${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index * 15)).toString().split(' ')[0]}'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: ${index % 2 == 0 ? 'Blood Test' : 'X-Ray'}'),
                    Text('Ordered by: Dr. Smith'),
                    Text('Location: Main Clinic'),
                    Text('Results: Normal'),
                    Text('Next Test: ${DateTime.now().add(Duration(days: 90)).toString().split(' ')[0]}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InjectionHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Injection ${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index * 5)).toString().split(' ')[0]}'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: ${index % 2 == 0 ? 'Vaccine' : 'Medicine'}'),
                    Text('Given by: Nurse Emma'),
                    Text('Location: Home Visit'),
                    Text('Time: ${9 + index}:30 AM'),
                    Text('Next Due: ${DateTime.now().add(Duration(days: 30)).toString().split(' ')[0]}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 