import 'package:flutter/material.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(const LocationRemembererApp());
}

class LocationRemembererApp extends StatelessWidget {
  const LocationRemembererApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remember the Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RegistrationScreen(),
    );
  }
}