import 'package:flutter/material.dart';
import 'package:icecream_animation/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icecream Animation',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

