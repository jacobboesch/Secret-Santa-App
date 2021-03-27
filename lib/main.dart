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
        theme: ThemeData(primarySwatch: Colors.green),
        home: DefaultTabController(
          initialIndex: 0,
          length: 2,
          // Two tabs first one is for viewing participants
          // second one is for viewing households
          child: HomeScreen(),
        ));
  }
}
