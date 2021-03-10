import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SecretSantaApp());
}

// Application
class SecretSantaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
