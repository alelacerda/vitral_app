import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';
import '../uikit/images.dart';

class LocationCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String workingHours;
  final VoidCallback onPressed;

  const LocationCard({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.workingHours,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: UIColor.white,
      elevation: 5,
      shadowColor: UIColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.asset(
                  ImageAssets.locationCover,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: CustomTextStyle.title3.copyWith(
                        color: UIColor.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: CustomTextStyle.body2.copyWith(
                        color: UIColor.black,
                      ),
                    ),
                    Text(
                      phone,
                      style: CustomTextStyle.body2.copyWith(
                        color: UIColor.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}