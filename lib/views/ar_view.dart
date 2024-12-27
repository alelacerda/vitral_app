import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class ARView extends StatelessWidget {
  const ARView({super.key});

  static const MethodChannel _methodChannel = MethodChannel('ar_view_channel');

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        body: UiKitView(
          viewType: 'ARView',
          onPlatformViewCreated: (id) => _onPlatformViewCreated(context, id),
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

  void _onPlatformViewCreated(BuildContext context, int id) {
    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'goBack') {
        Navigator.of(context).pop();
      }
    });
  }
}
