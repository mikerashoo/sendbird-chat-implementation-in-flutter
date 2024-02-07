import 'package:flutter/material.dart'; 
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Theme Demo',
      theme: ThemeData.dark().copyWith(
        backgroundColor: const Color(0xFFD9D9D9), // Set the background color
      ),
      home: const HomeScreen(),
    );
  }
}
