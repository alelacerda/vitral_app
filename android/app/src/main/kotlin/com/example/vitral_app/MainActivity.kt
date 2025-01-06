package com.example.vitral_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val channelName = "ar_view_channel"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize the MethodChannel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)

        // Register the ARViewFactory and pass the MethodChannel
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("ARView", ARViewFactory(methodChannel!!))
    }

    override fun onDestroy() {
        super.onDestroy()
        // Clean up the MethodChannel when the activity is destroyed
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }
}
