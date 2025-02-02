package com.shinriyo.subzero

import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SubzeroPlugin */
class SubzeroPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.shinriyo.subzero.reflection")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "copyWithModel" -> {
        val properties = call.argument<Map<String, Any>>("properties")
        result.success(properties)
      }
      "toJson" -> {
        result.success(toJson(call))
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun toJson(call: MethodCall): Map<String, Any?> {
    // デバッグ出力を追加
    Log.d("SubzeroPlugin", "toJson called with arguments: ${call.arguments}")
    
    // Get instance from arguments
    val instance = call.argument<Any>("instance") ?: return emptyMap()
    Log.d("SubzeroPlugin", "instance: $instance")
    
    // テスト用のハードコードされた値を探す
    val clazz = instance::class.java
    for (field in clazz.declaredFields) {
        field.isAccessible = true
        Log.d("SubzeroPlugin", "field: ${field.name}, value: ${field.get(instance)}")
    }
    
    // Get current values from instance using reflection
    val properties = instance::class.memberProperties
    val json = mutableMapOf<String, Any?>()
    
    for (property in properties) {
      val value = property.getter.call(instance)
      json[property.name] = value
      Log.d("SubzeroPlugin", "property: ${property.name}, value: $value")
    }
    
    Log.d("SubzeroPlugin", "returning json: $json")
    return json
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
