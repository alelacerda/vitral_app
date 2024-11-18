import 'package:flutter/material.dart';
import '../uikit/images.dart';
import '../uikit/ui_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final IconData leftIcon;
  final IconData rightIcon;
  final showBackButton;
  final bool hideLogo;

  const CustomAppBar({super.key, 
    required this.title,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.leftIcon,
    required this.rightIcon,
    this.showBackButton = false,
    this.hideLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        child: AppBar(
          backgroundColor: UIColor.darkPurple,
          elevation: 0,
          leading: showBackButton ?
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: IconButton(
                icon: Icon(Icons.chevron_left_rounded, color: UIColor.white, size: 32),
                onPressed: onLeftButtonPressed,
              ),
            )
            : Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: IconButton(
                icon: Icon(leftIcon, color: UIColor.white, size: 32),
                onPressed: onLeftButtonPressed,
              ),
            ),
          title: hideLogo ? null : Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Image.asset(
              ImageAssets.logoHorizontal, 
              width: 136,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: IconButton(
                icon: Icon(rightIcon, color: UIColor.white, size: 32),
                onPressed: onRightButtonPressed,
              ),
            ),
          ],
        ),
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
