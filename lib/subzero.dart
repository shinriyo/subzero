import 'package:flutter/services.dart';

class Subzero {
  static const MethodChannel _channel =
      MethodChannel('com.shinriyo.subzero.reflection');

  // copyWithメソッドを呼び出す
  static Future<Map<String, dynamic>> copyWith(
      String className, Map<String, dynamic> properties) async {
    final result = await _channel.invokeMethod('copyWithModel', {
      'className': className,
      'properties': properties,
    });

    // 返り値がMap<String, dynamic>になるようにキャスト
    return Map<String, dynamic>.from(result);
  }

  // toJsonメソッドを呼び出す
  static Future<Map<String, dynamic>> toJson(
      String className, Map<String, dynamic> properties) async {
    final result = await _channel.invokeMethod('toJson', {
      'className': className,
      'properties': properties,
    });

    // 返り値がMap<String, dynamic>になるようにキャスト
    return Map<String, dynamic>.from(result);
  }
}
