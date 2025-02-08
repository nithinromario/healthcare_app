import 'package:flutter/material.dart';

class BaseMedicalScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final Map<String, dynamic>? userData;

  const BaseMedicalScreen({
    Key? key,
    required this.title,
    required this.body,
    this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    );
  }
}
