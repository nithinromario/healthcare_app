import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import '../firebase_options.dart';

class AuthException implements Exception {
  final String message;
  final String? code;
  AuthException(this.message, [this.code]);
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Cached email check results
  final Map<String, bool> _emailExistsCache = {};

  // List of available specializations
  static const List<String> specializations = [
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Neurologist',
    'Orthopedist',
    'Psychiatrist',
    'Gynecologist',
    'Ophthalmologist',
    'General Physician',
    'Dentist'
  ];

  // Check if email exists with caching
  Future<bool> emailExists(String email) async {
    final trimmedEmail = email.trim();
    
    // Check cache first
    if (_emailExistsCache.containsKey(trimmedEmail)) {
      return _emailExistsCache[trimmedEmail]!;
    }

    try {
      final list = await _auth.fetchSignInMethodsForEmail(trimmedEmail);
      final exists = list.isNotEmpty;
      // Cache the result
      _emailExistsCache[trimmedEmail] = exists;
      return exists;
    } catch (e) {
      _logger.e('Error checking email: $e');
      return false;
    }
  }

  // Sign Up Method
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String userType,
    required String name,
    String? specialization,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final trimmedEmail = email.trim().toLowerCase();

      _logger.d('Starting signup process for $trimmedEmail');

      // Prepare user data first to minimize time after auth creation
      final Map<String, dynamic> userData = {
        'name': name.trim(),
        'email': trimmedEmail,
        'userType': userType.toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        if (userType.toLowerCase() == 'doctor' && specialization?.isNotEmpty == true)
          'specialization': specialization!.trim(),
      };

      _logger.d('Creating Firebase Auth account...');
      // Create user in Firebase Auth
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      if (authResult.user == null) {
        stopwatch.stop();
        _logger.e('Failed to create account. Time elapsed: ${stopwatch.elapsedMilliseconds}ms');
        return {'success': false, 'message': 'Failed to create account'};
      }

      _logger.d('Firebase Auth account created in ${stopwatch.elapsedMilliseconds}ms');

      // Create user document in Firestore
      _logger.d('Creating Firestore document...');
      await _firestore.collection('users').doc(authResult.user!.uid).set(userData);

      stopwatch.stop();
      _logger.d('Account creation completed in ${stopwatch.elapsedMilliseconds}ms');

      // Send email verification
      await authResult.user!.sendEmailVerification();
      
      return {
        'success': true,
        'message': 'Account created successfully',
        'uid': authResult.user!.uid,
        'timeElapsed': stopwatch.elapsedMilliseconds,
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered. Please login instead.';
          break;
        case 'invalid-email':
          message = 'Invalid email format';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        default:
          message = e.message ?? 'Registration failed';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      _logger.e('Unexpected error during signup: $e');
      return {
        'success': false,
        'message': 'Registration failed. Please try again.',
      };
    }
  }

  // Sign In Method
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final trimmedEmail = email.trim().toLowerCase();
      
      // Sign in with Firebase Auth
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      if (authResult.user == null) {
        return {'success': false, 'message': 'Login failed'};
      }

      // Get user data from Firestore with offline persistence
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(authResult.user!.uid)
            .get(const GetOptions(source: Source.cache));

        if (!userDoc.exists) {
          return {
            'success': false,
            'message': 'User data not found. Please check your internet connection.',
          };
        }

        final userData = userDoc.data()!;
        
        // Cache user data locally
        await _firestore.collection('users').doc(authResult.user!.uid).set(
          userData,
          SetOptions(merge: true),
        );
        
        return {
          'success': true,
          'message': 'Login successful',
          'uid': authResult.user!.uid,
          'userType': userData['userType'],
          'userData': userData,
        };
      } on FirebaseException catch (e) {
        // If offline and no cached data, try to create basic user data
        if (e.code == 'unavailable') {
          final basicUserData = {
            'email': trimmedEmail,
            'userType': 'patient', // default type
            'lastLoginAt': FieldValue.serverTimestamp(),
          };

          // Try to set data with merge to avoid overwriting existing data when back online
          await _firestore.collection('users').doc(authResult.user!.uid).set(
            basicUserData,
            SetOptions(merge: true),
          );

          return {
            'success': true,
            'message': 'Login successful (offline mode)',
            'uid': authResult.user!.uid,
            'userType': 'patient',
            'userData': basicUserData,
          };
        }
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email format';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = e.message ?? 'Login failed';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      _logger.e('Unexpected error during login: $e');
      return {
        'success': false,
        'message': 'Login failed. Please check your internet connection and try again.',
      };
    }
  }

  // Initialize Firestore settings for offline persistence
  Future<void> initializeFirestore() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _initializeDummyData();
    await FirebaseFirestore.instance.enablePersistence();
  }

  Future<void> _initializeDummyData() async {
    // Add dummy users
    await _firestore.collection('users').doc('doctor1').set({
      'id': 'doctor1',
      'name': 'Dr. Sarah Smith',
      'email': 'sarah.smith@example.com',
      'type': 'doctor',
      'specialization': 'Cardiologist',
      'phone': '+1122334455',
      'address': '456 Hospital Ave, City',
      'licenseNumber': 'MED123456'
    });

    await _firestore.collection('users').doc('doctor2').set({
      'id': 'doctor2',
      'name': 'Dr. Michael Chen',
      'email': 'michael.chen@example.com',
      'type': 'doctor',
      'specialization': 'Pediatrician',
      'phone': '+1122334466',
      'address': '789 Medical Center, City',
      'licenseNumber': 'MED789012'
    });

    await _firestore.collection('users').doc('nurse1').set({
      'id': 'nurse1',
      'name': 'Emily Johnson',
      'email': 'emily.johnson@example.com',
      'type': 'nurse',
      'phone': '+1567890123',
      'address': '789 Care St, City',
      'licenseNumber': 'NUR789012'
    });

    // Add dummy appointments
    await _firestore.collection('appointments').add({
      'patientId': 'patient1',
      'providerId': 'doctor1',
      'providerName': 'Dr. Sarah Smith',
      'providerType': 'doctor',
      'appointmentDateTime': DateTime.now().add(const Duration(days: 2)),
      'status': 'confirmed',
      'reason': 'Regular checkup',
      'notes': 'Follow-up on previous visit'
    });

    // Add dummy prescriptions
    await _firestore.collection('prescriptions').add({
      'patientId': 'patient1',
      'doctorId': 'doctor1',
      'doctorName': 'Dr. Sarah Smith',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'diagnosis': 'Hypertension',
      'medications': [
        {
          'name': 'Lisinopril',
          'dosage': '10mg',
          'frequency': 'Once daily',
          'duration': '30 days'
        },
        {
          'name': 'Amlodipine',
          'dosage': '5mg',
          'frequency': 'Once daily',
          'duration': '30 days'
        }
      ],
      'notes': 'Take with food. Monitor blood pressure regularly.'
    });

    // Add dummy lab reports
    await _firestore.collection('lab_reports').add({
      'patientId': 'patient1',
      'doctorId': 'doctor1',
      'doctorName': 'Dr. Sarah Smith',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'testName': 'Complete Blood Count',
      'labName': 'City Medical Lab',
      'results': [
        {
          'parameter': 'Hemoglobin',
          'value': '14.5',
          'unit': 'g/dL',
          'referenceRange': '13.5-17.5',
          'status': 'normal'
        },
        {
          'parameter': 'White Blood Cells',
          'value': '11.5',
          'unit': 'K/µL',
          'referenceRange': '4.5-11.0',
          'status': 'high'
        },
        {
          'parameter': 'Platelets',
          'value': '250',
          'unit': 'K/µL',
          'referenceRange': '150-450',
          'status': 'normal'
        }
      ],
      'notes': 'Slightly elevated WBC count, may indicate infection.'
    });
  }

  // Clear email cache
  void clearEmailCache() {
    _emailExistsCache.clear();
  }

  // Sign Out Method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _logger.d('User signed out successfully');
    } catch (e) {
      _logger.e('Error during sign out: $e');
      throw AuthException('Failed to sign out');
    }
  }

  // Get Current User
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get(const GetOptions(source: Source.cache));
        return doc.data();
      }
      return null;
    } catch (e) {
      _logger.e('Error getting current user: $e');
      throw AuthException('Failed to get user data');
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException('Please enter a valid email address');
      }
      await _auth.sendPasswordResetEmail(email: email.trim());
      _logger.d('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase Auth Error during password reset: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          throw AuthException('No user found with this email', e.code);
        case 'invalid-email':
          throw AuthException('Invalid email address', e.code);
        default:
          throw AuthException('Password reset failed: ${e.message}', e.code);
      }
    } catch (e) {
      _logger.e('Error sending password reset email: $e');
      throw AuthException('Failed to send password reset email');
    }
  }

  // Update User Profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? specialization,
  }) async {
    try {
      final updates = <String, dynamic>{
        'lastUpdated': DateTime.now(),
      };
      if (name != null) updates['name'] = name.trim();
      if (specialization != null) updates['specialization'] = specialization.trim();

      await _firestore.collection('users').doc(userId).update(updates);
      _logger.d('Profile updated successfully for user: $userId');
    } catch (e) {
      _logger.e('Error updating profile: $e');
      throw AuthException('Failed to update profile');
    }
  }

  // Check Email Verification
  Future<bool> isEmailVerified() async {
    try {
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } catch (e) {
      _logger.e('Error checking email verification: $e');
      throw AuthException('Failed to check email verification status');
    }
  }

  // Send Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      _logger.d('Verification email sent successfully');
    } catch (e) {
      _logger.e('Error sending verification email: $e');
      throw AuthException('Failed to send verification email');
    }
  }

  // Helper method to get error messages
  String _getAuthErrorMessage(FirebaseAuthException e) {
    _logger.d('Translating auth error code: ${e.code}');
    switch (e.code) {
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please try logging in instead.';
      case 'invalid-email':
        return 'The email address is not valid. Please check and try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters with a mix of letters and numbers.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again or reset your password.';
      case 'invalid-credential':
        return 'The email or password is incorrect. Please try again.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'timeout':
        return 'The request timed out. Please check your internet connection and try again.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
