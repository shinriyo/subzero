package com.shinriyo.subzero

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
        try {
          val data = call.argument<Map<String, Any>>("data")
          val current = call.argument<Map<String, Any>>("current")
          val fields = call.argument<Map<String, String>>("fields")

          if (data == null || current == null || fields == null) {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
            return
          }

          val updatedData = current.toMutableMap()
          data.forEach { (key, value) -> 
            updatedData[key] = value 
          }

          result.success(updatedData)
        } catch (e: Exception) {
          result.error("ERROR", e.message, null)
        }
      }
      "toJson" -> {
        try {
          val args = call.arguments<Map<String, Any>>()
          val data = args?.get("data") as? Map<String, Any>
          
          if (data == null) {
            result.error("INVALID_ARGUMENTS", "Missing data argument", null)
            return
          }
          
          result.success(data)
        } catch (e: Exception) {
          result.error("ERROR", e.message, null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
