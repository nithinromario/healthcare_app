import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../presenters/auth_presenter.dart';
import '../../services/user_data_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements AuthViewContract {
  final _formKey = GlobalKey<FormState>();
  late AuthPresenter _presenter;
  
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _presenter = AuthPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 24),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: Text('Login'),
                ),
              TextButton(
                onPressed: () {
                  // Navigate to signup screen
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      // Mock login logic using UserDataService
      try {
        // Check doctors
        final doctor = UserDataService.doctors.firstWhere(
          (d) => d['email'] == _email,
          orElse: () => {},
        );
        if (doctor.isNotEmpty) {
          onLoginSuccess(UserDataService.getUserById(doctor['id']));
          return;
        }

        // Check nurses
        final nurse = UserDataService.nurses.firstWhere(
          (n) => n['email'] == _email,
          orElse: () => {},
        );
        if (nurse.isNotEmpty) {
          onLoginSuccess(UserDataService.getUserById(nurse['id']));
          return;
        }

        // Check patients
        final patient = UserDataService.patients.firstWhere(
          (p) => p['email'] == _email,
          orElse: () => {},
        );
        if (patient.isNotEmpty) {
          onLoginSuccess(UserDataService.getUserById(patient['id']));
          return;
        }

        onLoginError('User not found');
      } catch (e) {
        onLoginError(e.toString());
      }
    }
  }

  @override
  void onLoginSuccess(User user) {
    setState(() => _isLoading = false);
    // Navigate to appropriate dashboard based on user type
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _getDashboardForUserType(user),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  void onSignupSuccess(User user) {
    // Not used in login screen
  }

  @override
  void onSignupError(String error) {
    // Not used in login screen
  }

  Widget _getDashboardForUserType(User user) {
    // TODO: Implement dashboard routing based on user type
    return Scaffold(body: Center(child: Text('Dashboard')));
  }
} 