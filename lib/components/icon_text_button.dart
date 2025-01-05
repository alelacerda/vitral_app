import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class IconTextButton extends StatelessWidget {
  final String iconName;
  final String text;
  final VoidCallback onPressed;

  const IconTextButton({
    super.key, 
    required this.iconName,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent, 
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          children: <Widget>[
            Image.asset(
              iconName,
              width: 24,
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                text,
                style: CustomTextStyle.body2.copyWith(color: UIColor.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
