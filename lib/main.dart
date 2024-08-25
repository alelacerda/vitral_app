import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/articles_view.dart';
import 'views/camera_view.dart';
import 'views/map_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vitRAl',
      home: const HomePage(),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    ArticlesView(),
    HomeView(),
    CameraView(),
    MapView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
              icon: _selectedIndex == 0
                ? const Icon(Icons.book, color: Colors.black, size: 32)
                : const Icon(Icons.book_outlined, color: Colors.black, size: 32),
              label: 'Leitura',
              ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                ? const Icon(Icons.home, color: Colors.black, size: 32)
                : const Icon(Icons.home_outlined, color: Colors.black, size: 32),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                ? const Icon(Icons.camera_alt, color: Colors.black, size: 32)
                : const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 32),
              label: 'RA',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                ? const Icon(Icons.map, color: Colors.black, size: 32)
                : const Icon(Icons.map_outlined, color: Colors.black, size: 32),
              label: 'Mapa',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
        ),
      ),
    );

  }
}