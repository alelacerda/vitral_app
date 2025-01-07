package com.example.vitral_app;

import android.content.Intent;
import androidx.annotation.NonNull;
import com.google.ar.core.examples.java.augmentedimage.AugmentedImageActivity;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.util.Log;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "ar_view_channel";

  private MethodChannel methodChannel;

  public void openAR() {
      Intent intent = new Intent(MainActivity.this, AugmentedImageActivity.class);
      startActivity(intent);
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
    
    methodChannel.setMethodCallHandler(
      (call, result) -> {
        if (call.method.equals("launchAndroidActivity")) {
          openAR();
          Log.d("MainActivity", "launchAndroidActivity");
        } else {

          Log.d("MainActivity", "Method not implemented");
          result.notImplemented();
        }
      }
    );
    }
}

