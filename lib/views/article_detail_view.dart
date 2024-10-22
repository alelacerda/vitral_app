import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/article.dart';
import '../uikit/ui_colors.dart';

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
          Text(
          article.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Html(
          data: article.content,
          ),
        ],
        ),
      ),
      ),
    );
  }
}