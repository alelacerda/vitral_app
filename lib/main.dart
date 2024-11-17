import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        fontFamily: 'FiraSans',
        primarySwatch: Colors.grey,
        bottomAppBarTheme: const BottomAppBarTheme (
          color: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}

