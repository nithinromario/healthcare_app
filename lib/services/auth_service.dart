import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String userType,
    String? specialization,
    String? licenseNumber,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'userType': userType,
        'specialization': specialization,
        'licenseNumber': licenseNumber,
        'createdAt': DateTime.now(),
      });

      return userCredential;
    } catch (e) {
      print('Error during signup: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error during signin: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user type
  Future<String?> getCurrentUserType() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.get('userType');
    }
    return null;
  }
} 