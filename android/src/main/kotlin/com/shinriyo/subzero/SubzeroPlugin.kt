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
        try {
          val data = call.argument<Map<String, Any>>("data")
          val type = call.argument<String>("type")
          val fields = call.argument<Map<String, String>>("fields")

          if (data == null || type == null || fields == null) {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
            return
          }

          // Keep current data
          val updatedData = data.toMutableMap()

          // Process each property from fields
          fields.forEach { (name, type) ->
            if (!updatedData.containsKey(name)) {
              updatedData[name] = when (type.toLowerCase()) {
                "string" -> ""
                "int" -> 0
                "bool", "boolean" -> false
                else -> Any()
              } as Any
            }
          }

          result.success(updatedData)
        } catch (e: Exception) {
          result.error("ERROR", e.message, null)
        }
      }
      "toJson" -> {
        try {
          val args = call.arguments<Map<String, Any>>()
          if (args == null) {
            result.error("INVALID_ARGUMENTS", "Arguments must be a map", null)
            return
          }
          result.success(args)
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
