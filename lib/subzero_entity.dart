import 'package:flutter/services.dart';

/// A mixin that provides reflection capabilities to a class.
///
/// This mixin adds [copyWith] and [toJson] functionality using platform channels
/// to communicate with native code.
///
/// Example usage:
/// ```dart
/// class Person with SubzeroEntity {
///   final String name;
///   final int age;
///
///   Person({required this.name, required this.age});
///
///   @override
///   String get className => 'Person';
/// }
/// ```
mixin SubzeroEntity {
  static const MethodChannel _channel =
      MethodChannel('com.shinriyo.subzero.reflection');

  /// Returns the class name (must be implemented)
  String get className;

  Future<T> copyWith<T>(Map<String, dynamic> properties) async {
    final result = await _channel.invokeMethod('copyWithModel', {
      'className': className,
      'properties': properties,
    });

    return result as T;
  }

  Future<Map<String, dynamic>> toJson() async {
    final result = await _channel.invokeMethod('toJson', {
      'className': className,
      'properties': {}, // 空のMapを送信し、Swift側でリフレクションを使用
    });

    return Map<String, dynamic>.from(result);
  }
}
