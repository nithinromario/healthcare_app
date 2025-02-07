import '../models/user.dart';

class UserDataService {
  // Mock data for demonstration - replace with actual database/API calls
  static final List<Map<String, dynamic>> doctors = [
    {
      'id': 'd1',
      'name': 'Dr.kaipulla',
      'email': 'kaipulla@gmail.com',
      'phone': '984648737',
      'specialization': 'Cardiologist',
      'licenseNumber': 'MD12345',
      'experience': '15 years',
      'availability': 'Mon-Fri, 9AM-5PM',

      'hospital': 'City General Hospital'
    },
    {
      'id': 'd2',
      'name': 'Dr.nithin',
      'email': 'nithin@gmail.com',
      'phone': '973573836',
      'specialization': 'Pediatrician',
      'licenseNumber': 'MD12346',
      'experience': '10 years',
      'availability': 'Mon-Sat, 10AM-6PM',

      'hospital': 'Children\'s Medical Center'
    },
    {
      'id': 'd3',
      'name': 'Dr.narasimma',
      'email': 'narasimma@healthcare.com',
      'phone': '984648737',
      'specialization': 'Neurologist',
      'licenseNumber': 'MD12347',
      'experience': '12 years',
      'availability': 'Tue-Sat, 8AM-4PM',
      'hospital': 'Neurology Institute'
    }
  ];

  static final List<Map<String, dynamic>> nurses = [
    {
      'id': 'n1',
      'name': ' Nurse chandra',
      'email': 'chandra@gmail.com',
      'phone': '984648737',
      'licenseNumber': 'RN98765',
      'specialization': 'Critical Care',
      'experience': '8 years',
      'shift': 'Morning Shift',

      'assignedDoctor': 'd1'

    },
    {
      'id': 'n2',
      'name': 'Nurse ',
      'email': 'maariyamma@gmail.com',
      'phone': '984648737',
      'licenseNumber': 'RN98766',
      'specialization': 'Pediatric Care',
      'experience': '5 years',
      'shift': 'Evening Shift',
      'assignedDoctor': 'd2'

    },
    {
      'id': 'n3',
      'name': 'Nurse meena',
      'email': 'meena@gmail.com',
      'phone': '984648737',
      'licenseNumber': 'RN98767',
      'specialization': 'Home Care',
      'experience': '7 years',
      'shift': 'Flexible',

      'assignedDoctor': 'd3'
    }
  ];

  static final List<Map<String, dynamic>> patients = [
    {
      'id': 'p1',
      'name': 'johny',
      'email': 'johny@gmail.com',
      'phone': '984648737',
      'dateOfBirth': '1985-05-15',
      'bloodGroup': 'O+',
      'address': '123 Main,kumbakonam',
      'emergencyContact': '984648737',


      'allergies': ['Penicillin'],
      'assignedDoctor': 'd1'
    },
    {
      'id': 'p2',
      'name': 'romario',
      'email': 'romario@gmail.com',
      'phone': '984648737',
      'dateOfBirth': '1990-08-22',
      'bloodGroup': 'A-',
      'address': '456 Oak Ave, City',
      'emergencyContact': '984648737',

      'allergies': ['None'],
      'assignedDoctor': 'd2'
    },
    {
      'id': 'p3',
      'name': 'Ronaldo',
      'email': 'ronaldo@gmail.com',
      'phone': '984648737',
      'dateOfBirth': '1978-12-10',
      'bloodGroup': 'B+',
      'address': 'marthandam',
      'emergencyContact': '984648737',

      'allergies': ['Sulfa', 'Aspirin'],
      'assignedDoctor': 'd3'
    }
  ];

  static User getUserById(String id) {
    if (id.startsWith('d')) {
      final doctor = doctors.firstWhere((d) => d['id'] == id);
      return User(
        id: doctor['id'],
        name: doctor['name'],
        email: doctor['email'],
        phone: doctor['phone'],
        userType: UserType.doctor,
        specialization: doctor['specialization'],
        licenseNumber: doctor['licenseNumber'],
      );
    } else if (id.startsWith('n')) {
      final nurse = nurses.firstWhere((n) => n['id'] == id);
      return User(
        id: nurse['id'],
        name: nurse['name'],
        email: nurse['email'],
        phone: nurse['phone'],
        userType: UserType.nurse,
        specialization: nurse['specialization'],
        licenseNumber: nurse['licenseNumber'],
      );
    } else {
      final patient = patients.firstWhere((p) => p['id'] == id);
      return User(
        id: patient['id'],
        name: patient['name'],
        email: patient['email'],
        phone: patient['phone'],
        userType: UserType.patient,
      );
    }
  }

  static List<Map<String, dynamic>> getDoctorsList() => doctors;
  static List<Map<String, dynamic>> getNursesList() => nurses;
  static List<Map<String, dynamic>> getPatientsList() => patients;
} 