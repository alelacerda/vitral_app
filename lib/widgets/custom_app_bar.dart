import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final IconData leftIcon;
  final IconData rightIcon;

  const CustomAppBar({super.key, 
    required this.title,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.leftIcon,
    required this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(leftIcon, color: Colors.black),
        onPressed: onLeftButtonPressed,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(rightIcon, color: Colors.black),
          onPressed: onRightButtonPressed,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.black,
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
