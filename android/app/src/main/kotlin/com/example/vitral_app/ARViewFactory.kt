package com.example.vitral_app

import android.content.Context
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ARViewFactory(private val methodChannel: MethodChannel) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        // Pass the MethodChannel to the ARView
        return ARView(context, methodChannel)
    }
}
