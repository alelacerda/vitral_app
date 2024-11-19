import 'package:flutter/material.dart';
import '../uikit/images.dart';

class TemporaryView extends StatelessWidget {
  const TemporaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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