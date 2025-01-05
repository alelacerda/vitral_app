import 'package:flutter/material.dart';
import '../uikit/images.dart';
import '../uikit/ui_colors.dart';

class TemporaryView extends StatelessWidget {
  const TemporaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.white,
      body: 
        Center(
            child: 
              Image.asset(
                ImageAssets.temporaryView, 
                width: 283,
              ), 
        ),
    );
  }
}