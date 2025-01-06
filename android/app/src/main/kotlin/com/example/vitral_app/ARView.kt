package com.example.vitral_app

import android.content.Context
import android.view.View
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import androidx.compose.runtime.*
import androidx.compose.ui.platform.ComposeView
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

     private val composeView: ComposeView = ComposeView(context).apply {
         setContent {
             ComposeContent()
         }
     }

    init {
        layout.addView(textView)
        layout.addView(button)
        layout.addView(composeView) 
    }

    @Composable
    fun ComposeContent() {
        var selectedCategory by remember { mutableStateOf<Category?>(Category.FUNFACTS) }
        CategorySelector(
            selectedCategory = selectedCategory,
            onCategorySelected = { selectedCategory = it }
        )
    }

    override fun getView(): View {
        return layout
    }

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
    }
}
