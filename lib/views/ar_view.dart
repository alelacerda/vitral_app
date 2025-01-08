import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import '../api.dart';
import '../models/article.dart';

class ARView extends StatelessWidget {
  final Function(BuildContext, Article) onNavigateToArticle;

  const ARView({super.key, required this.onNavigateToArticle});

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
    } else if (Platform.isAndroid) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _launchAndroidActivity,
            child: const Text('Abrir Realidade Aumentada'),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleGoBack(context);
        },
        child: const Icon(Icons.add),
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

  Future<void> _handleGoBack(context) async {
    print("Go back");
    Navigator.of(context).pop();
  }

  Future<Object> _handleGetStainedGlassInfo(dynamic arguments) async {
    var stainedGlass = await getStainedGlass(arguments);

    if (stainedGlass['informationIds'] == null) {
      print("Error: stainedGlass['informationIds'] is null");
      return {'error': 'Invalid stained glass info'};
    }

    try {
      // Ensure the IDs are valid, remove null or empty values
      List<String> ids = List<String>.from(stainedGlass['informationIds']?.where((id) => id != null && id.isNotEmpty) ?? []);

      if (ids.isEmpty) {
        print("Error: No valid IDs found");
        return {'error': 'No valid IDs found'};
      }

      final stainedGlassInfo = await Api.fetchStainedGlassesInfo(ids);
      
      return stainedGlassInfo.map((info) => info.toJson()).toList();
    } catch (e) {
      print("Error fetching stained glass info: $e");
      return {'error': 'Failed to fetch stained glass info'};
    }
  }

  Future<void> _handleNavigateToArticle(context, dynamic arguments) async {
    final article = await Api.fetchArticleWithId(arguments);

    onNavigateToArticle(context, article);
  }

  void _launchAndroidActivity() {
    print("Launching Android Activity...");
    _methodChannel.invokeMethod('launchAndroidActivity');
  }

  Future<Map<String, dynamic>> getStainedGlass(arguments) async {
    try {
      final stainedGlass = await Api.fetchStainedGlass(arguments);
      if (stainedGlass != null) {
        print ("Stained glass found: $stainedGlass");
        return stainedGlass.toJson();
      } else {
        print("Stained glass not found.");
        return {'error': 'Stained glass not found'};
      }
    } catch (e) {
      print("Error fetching stained glass info: $e");
      return {'error': 'Failed to fetch stained glass info'};
    }
  }

  Future<void> onARViewOpened (dynamic arguments) async {
    print("AR View Opened with arguments: $arguments");
  }

  void _onPlatformViewCreated(BuildContext context, int id) {
    _methodChannel.setMethodCallHandler((call) async {
      final methodHandlers = {
        'goBack': () => _handleGoBack(context),
        'getStainedGlassInfo': () => _handleGetStainedGlassInfo(call.arguments),
        'goToArticle': () => _handleNavigateToArticle(context, call.arguments),
        'onARViewOpened': () => onARViewOpened(call.arguments),
      };

      final handler = methodHandlers[call.method];
      if (handler != null) {
        return await handler();
      } else {
        throw PlatformException(
          code: 'METHOD_NOT_IMPLEMENTED',
          message: 'Method ${call.method} is not implemented.',
        );
      }
    });
  }
}
