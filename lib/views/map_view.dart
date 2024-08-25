import 'package:flutter/material.dart';
import '../view_models/map_view_model.dart';

class MapView extends StatelessWidget {
  final MapViewModel viewModel = MapViewModel();

  MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Center(child: Text(viewModel.title)),
    );
  }
}