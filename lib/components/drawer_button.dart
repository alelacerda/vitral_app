import 'package:flutter/material.dart';
import '../uikit/text_style.dart';
import '../uikit/ui_colors.dart';

class DrawerButton extends StatelessWidget {
  final String iconName;
  final String text;
  final VoidCallback onPressed;

  const DrawerButton({
    super.key,
    required this.iconName,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        // width: 224,
        height: 88,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: UIColor.purple, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), 
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14), 
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                iconName,
                width: 50,
              ),
              const SizedBox(width: 8),
                Flexible(
                child: Text(
                  text.toUpperCase(),
                  style: CustomTextStyle.title2.copyWith(color: UIColor.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
