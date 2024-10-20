import 'package:flutter/material.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class ArticleCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onCardTap;
  final VoidCallback onButtonTap;

  const ArticleCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onCardTap,
    required this.onButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: UIColor.lightLilac,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Image on the left side
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10.0),
          //   child: Image.network(
          //     imageUrl,
          //     height: 80.0,
          //     width: 80.0,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // SizedBox(width: 10.0),

          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyle.title2.copyWith(color: UIColor.black),
            ),
            SizedBox(height: 4.0),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyle.body2.copyWith(color: UIColor.black),
            ),
              ],
            ),
          ),
            ],
          ),
          SizedBox(height: 8.0),

          // 'Ler mais' button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
          onPressed: onButtonTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: UIColor.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          child: Text(
            'Ler mais...',
            style: CustomTextStyle.button.copyWith(color: UIColor.white),
          ),
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }
}
