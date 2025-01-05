import 'package:flutter/material.dart';
import '../uikit/custom_icons.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(16.0),
      shadowColor: UIColor.black,
      child: TextField(
        style: CustomTextStyle.body2,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              CustomIcons.search,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
          filled: true,
          fillColor: UIColor.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
