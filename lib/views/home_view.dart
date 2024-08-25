import 'package:flutter/material.dart';
import '../view_models/home_view_model.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel viewModel = HomeViewModel();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Center(child: Text(viewModel.title)),
    );
  }
}