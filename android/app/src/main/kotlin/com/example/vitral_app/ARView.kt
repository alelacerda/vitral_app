package com.example.vitral_app

import android.content.Context
import android.view.View
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class ARView(context: Context, private val methodChannel: MethodChannel) : PlatformView {

    private val layout: LinearLayout = LinearLayout(context).apply {
        orientation = LinearLayout.VERTICAL
        setPadding(20, 20, 20, 20)
    }

    private val textView: TextView = TextView(context).apply {
        text = "Hello from Android View!"
        textSize = 20f
    }

    private val button: Button = Button(context).apply {
        text = "Go Back"
        setOnClickListener {
            methodChannel.invokeMethod("goBack", null)
        }
    }

    init {
        layout.addView(textView)
        layout.addView(button)
    }

    override fun getView(): View {
        return layout
    }

    override fun dispose() {
        // Clean up the MethodChannel listener
        methodChannel.setMethodCallHandler(null)
    }
}
