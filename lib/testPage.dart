import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class testScreen extends StatefulWidget {

  const testScreen({super.key});

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        'Login Successful',
        style: TextStyle(
          fontSize: 60
        ),
      ),
    );
  }
}
