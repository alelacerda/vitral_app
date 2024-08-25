import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const CustomNavBar({
    super.key, 
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              icon: selectedIndex == 0
                ? const Icon(Icons.book, color: Colors.black, size: 32)
                : const Icon(Icons.book_outlined, color: Colors.black, size: 32),
              label: 'Leitura',
              ),
            BottomNavigationBarItem(
              icon: selectedIndex == 1
                ? const Icon(Icons.home, color: Colors.black, size: 32)
                : const Icon(Icons.home_outlined, color: Colors.black, size: 32),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: selectedIndex == 2
                ? const Icon(Icons.camera_alt, color: Colors.black, size: 32)
                : const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 32),
              label: 'RA',
            ),
            BottomNavigationBarItem(
              icon: selectedIndex == 3
                ? const Icon(Icons.map, color: Colors.black, size: 32)
                : const Icon(Icons.map_outlined, color: Colors.black, size: 32),
              label: 'Mapa',
            ),
          ],
          currentIndex: selectedIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
        ),
    );
  }
}