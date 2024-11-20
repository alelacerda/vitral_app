import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final String? iconName;
  final Color? borderColor;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = UIColor.purple,
    this.textColor = UIColor.white,
    this.iconName,
    this.borderColor,
  });

  Widget _buildChild() {
    if (iconName != null && iconName!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconName!,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 4),
          Text(
            text.toUpperCase(),
            style: CustomTextStyle.button.copyWith(
              color: textColor,
            ),
          ),
        ],
      );
    } else {
      return Text(
        text,
        style: CustomTextStyle.button.copyWith(
          color: textColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,
        ),
      ),
      child: _buildChild(),
    );
  }
}