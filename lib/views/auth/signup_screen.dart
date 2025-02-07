import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../presenters/auth_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> implements AuthViewContract {
  final _formKey = GlobalKey<FormState>();
  late AuthPresenter _presenter;
  late FirebaseAuth _auth;
  bool _isLoading = false;
  String _email = '';
  String _password = '';
  String _name = '';
  String _userType = '';
  String _specialization = '';
  String _licenseNumber = '';
  
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(child: Text('Signup Screen')), // TODO: Implement full UI
    );
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final result = await _auth.signUp(
          email: _email,
          password: _password,
          name: _name,
          userType: _userType,
          specialization: _specialization,
          licenseNumber: _licenseNumber,
        );
        
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created successfully!')),
          );
          
          // Navigate based on user type
          switch (_userType.toLowerCase()) {
            case 'patient':
              Navigator.pushReplacementNamed(context, '/patient_dashboard');
              break;
            case 'doctor':
              Navigator.pushReplacementNamed(context, '/doctor_dashboard');
              break;
            case 'nurse':
              Navigator.pushReplacementNamed(context, '/nurse_dashboard');
              break;
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Signup failed';
        
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account already exists for this email';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during signup')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void onLoginSuccess(User user) {}

  @override
  void onLoginError(String error) {}

  @override
  void onSignupSuccess(User user) {}

  @override
  void onSignupError(String error) {}
} 