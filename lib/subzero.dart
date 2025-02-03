import 'package:flutter/foundation.dart';
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

  Map<String, Type> get fields;
  // dynamic getField(String fieldName); // 抽象メソッドとして定義

  Map<String, dynamic> toMap() {
    final instance = this as dynamic;
    final result = <String, dynamic>{};

    for (var key in fields.keys) {
      switch (key) {
        case 'name':
          result[key] = instance.name;
        case 'age':
          result[key] = instance.age;
        case 'isActive':
          result[key] = instance.isActive;
      }
    }

    return result;
  }

  Future<T> copyWith<T>(Map<String, dynamic> properties) async {
    if (kDebugMode) {
      print('Sending data to native:');
      print('Type: ${runtimeType.toString()}');
      print('Properties: $properties');
      print('Fields: $fields');
    }

    try {
      final current = toMap();
      final merged = Map<String, dynamic>.from(current)..addAll(properties);

      final result = await _channel.invokeMethod('copyWithModel', {
        'data': merged,
        'type': runtimeType.toString(),
        'fields': fields.map((key, value) => MapEntry(key, value.toString())),
      });

      if (kDebugMode) {
        print('Received result: $result');
      }

      if (result is Map) {
        return Map<String, dynamic>.from(result) as T;
      }
      return result as T;
    } catch (e) {
      if (kDebugMode) {
        print('Error in copyWith: $e');
      }
      rethrow;
    }
  }

  Future<T> toJson<T>() async {
    try {
      return toMap() as T;
    } catch (e) {
      if (kDebugMode) {
        print('Error in toJson: $e');
      }
      rethrow;
    }
  }
}
