import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../presenters/auth_presenter.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> implements AuthViewContract {
  final _formKey = GlobalKey<FormState>();
  late AuthPresenter _presenter;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(child: Text('Signup Screen')), // TODO: Implement full UI
    );
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