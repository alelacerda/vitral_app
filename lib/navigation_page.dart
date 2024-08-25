import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/articles_view.dart';
import 'views/camera_view.dart';
import 'views/map_view.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_nav_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
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
      appBar: CustomAppBar(
        title: 'vitRAl',
        onLeftButtonPressed: () {
          Scaffold.of(context).openDrawer();
        },
        onRightButtonPressed: () {},
        leftIcon: Icons.menu,
        rightIcon: Icons.help_outline,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );

  }
}