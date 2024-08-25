import 'package:flutter/material.dart';
import '../view_models/articles_view_model.dart';

class ArticlesView extends StatelessWidget {
  final ArticlesViewModel viewModel = ArticlesViewModel();

  ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Center(child: Text(viewModel.title)),
    );
  }
}