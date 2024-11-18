import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class MenuButton extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onPressed;
  final bool clipImage;

  const MenuButton({super.key, 
    required this.image,
    required this.text,
    required this.onPressed,
    this.clipImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        width: 278,
        height: 120, 
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            elevation: 0,
            shadowColor: Colors.transparent,
            enableFeedback: false
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: UIColor.orange,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 123,
                right: 0,
                height: 100,
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    text,
                    style: CustomTextStyle.title1.copyWith(color: UIColor.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: clipImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          image,
                          width: 115,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        image,
                        width: 115,
                        fit: BoxFit.none,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

