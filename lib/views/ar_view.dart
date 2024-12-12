import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class ARView extends StatelessWidget {
  const ARView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AR View'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: UiKitView(
          viewType: 'ARView',
          onPlatformViewCreated: _onPlatformViewCreated,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AR View'),
        ),
        body: const Center(
          child: Text('AR functionality will be implemented here.'),
        ),
      );
    }
  }

  void _onPlatformViewCreated(int id) {
    // Handle platform view creation if needed
  }
}
