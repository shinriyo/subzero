import 'package:flutter/services.dart';

class Subzero {
  static const MethodChannel _channel =
      MethodChannel('com.shinriyo.subzero.reflection');

  // copyWithメソッドを呼び出す
  static Future<T> copyWith<T>(
      String className, Map<String, dynamic> properties) async {
    final result = await _channel.invokeMethod('copyWithModel', {
      'className': className,
      'properties': properties,
    });

    // 結果をそのまま返す（Mapのまま）
    return result as T;
  }

  // toJsonメソッドを呼び出す
  static Future<Map<String, dynamic>> toJson<T>(
    T object, {
    required String className,
    Map<String, dynamic>? properties,
  }) async {
    final result = await _channel.invokeMethod('toJson', {
      'className': className,
      'properties': properties ?? {},
    });

    return Map<String, dynamic>.from(result);
  }
}
