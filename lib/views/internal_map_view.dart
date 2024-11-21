import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class InternalMapView extends StatelessWidget {
  final String imageUrl;
  const InternalMapView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: UIColor.white,
        child: Center( child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text(
              "Mapa interno",
              style: CustomTextStyle.title1.copyWith(
                color: UIColor.black,
              ),
            ),
            const SizedBox(height: 32),
            Image.network(imageUrl),
          ],
        ),
      ),
      ),
    );
  }
}