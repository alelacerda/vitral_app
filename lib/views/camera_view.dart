import 'package:flutter/material.dart';
import '../view_models/camera_view_model.dart';

class CameraView extends StatelessWidget {
  final CameraViewModel viewModel = CameraViewModel();

  CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Center(child: Text(viewModel.title)),
    );
  }
}