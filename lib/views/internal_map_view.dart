import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';

class InternalMapView extends StatelessWidget {
  const InternalMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UIColor.white,
      child: const Center(
      child: Text('Internal Map View'),
      ),
    );
  }
}