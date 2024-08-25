import 'package:flutter/material.dart';
import 'navigation_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vitRAl',
      home: const NavigationPage(),
      theme: ThemeData(
        primarySwatch: Colors.grey,
        bottomAppBarTheme: const BottomAppBarTheme (
          color: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}

