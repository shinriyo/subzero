import 'package:flutter/services.dart';

/// A mixin that provides reflection-like capabilities for Dart classes.
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
///   Map<String, ({dynamic value, Type type})> get properties => {
///     'name': (value: name, type: String),
///     'age': (value: age, type: int),
///     'isActive': (value: isActive, type: bool),
///   };
/// }
///
/// // Usage:
/// final person = Person(name: 'Bob', age: 35);
/// final updatedPerson = await person.copyWith({
///   'name': 'Alice',
///   'age': 25,
/// });
/// ```
///
/// The [properties] getter should return a map containing both the current values
/// and their types for each property of your class.
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
