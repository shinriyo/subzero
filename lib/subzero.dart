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
///   final bool isActive;
///
///   Person({
///     required this.name,
///     required this.age,
///     this.isActive = false,
///   });
///
///   @override
///   Map<String, Type> get fields => {
///     'name': String,
///     'age': int,
///     'isActive': bool,
///   };
/// }
/// ```
/// Implement the [fields] getter to provide property information at runtime.
mixin SubzeroEntity {
  static const MethodChannel _channel =
      MethodChannel('com.shinriyo.subzero.reflection');

  // Return a Map of property values and their types
  Map<String, ({dynamic value, Type type})> get properties;

  Map<String, dynamic> toMap() {
    return properties.map((key, prop) => MapEntry(key, prop.value));
  }

  Future<T> copyWith<T>(Map<String, dynamic> properties) async {
    try {
      final currentValues = toMap();

      final result = await _channel.invokeMethod('copyWithModel', {
        'data': properties,
        'current': currentValues,
        'type': runtimeType.toString(),
        'fields': this
            .properties
            .map((key, prop) => MapEntry(key, prop.type.toString())),
      });

      if (result is Map) {
        return Map<String, dynamic>.from(result) as T;
      }
      return result as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> toJson<T>() async {
    try {
      final data = toMap();

      final result = await _channel.invokeMethod('toJson', {
        'type': runtimeType.toString(),
        'data': data,
        'fields':
            properties.map((key, prop) => MapEntry(key, prop.type.toString())),
      });

      if (result is Map) {
        return Map<String, dynamic>.from(result) as T;
      }
      return result as T;
    } catch (e) {
      rethrow;
    }
  }
}
