import 'package:flutter/material.dart';
import '../uikit/custom_icons.dart';
import '../uikit/ui_colors.dart';

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
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Prevent clipping
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image(image: AssetImage(CustomIcons.home), width: 45),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Image(image: AssetImage(CustomIcons.book), width: 45),
                  label: "Articles",
                ),
              ],
              currentIndex: selectedIndex,
              unselectedItemColor: UIColor.white,
              selectedItemColor: UIColor.white,
              backgroundColor: UIColor.darkPurple,
              onTap: onItemTapped,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              enableFeedback: false,
            ),
          ),
          Positioned(
            bottom: 32,
            left: MediaQuery.of(context).size.width / 2 - 49,
            child: GestureDetector(
              onTap: () => onItemTapped(1),
              child: Container(
                width: 98,
                height: 98,
                decoration: const BoxDecoration(
                  color: UIColor.orange,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Image(image: AssetImage(CustomIcons.camera), width: 45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}