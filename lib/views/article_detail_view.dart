import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/article.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class ArticleDetailView extends StatelessWidget {
  final Article article;

  const ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.white, // Set your desired background color here
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Html(
          data: article.content,
          style: {
            "p": Style(fontFamily: CustomTextStyle.fontFamily),
            "h1": Style(fontFamily: CustomTextStyle.fontFamily),
            "h2": Style(fontFamily: CustomTextStyle.fontFamily),
            "h3": Style(fontFamily: CustomTextStyle.fontFamily),
            "h4": Style(fontFamily: CustomTextStyle.fontFamily),
            "h5": Style(fontFamily: CustomTextStyle.fontFamily),
            "h6": Style(fontFamily: CustomTextStyle.fontFamily),
          },
          ),
        ],
        ),
      ),
      ),
    );
  }
}