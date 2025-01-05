import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class UnderlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const UnderlinedButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent, // Disable ripple effect if desired
      highlightColor: Colors.transparent, // Disable highlight effect if desired
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Text(
          text,
          style: CustomTextStyle.body2.copyWith(
            color: UIColor.black,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }
}
