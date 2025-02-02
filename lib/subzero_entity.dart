import 'package:flutter/services.dart';
import 'package:subzero/annotations.dart';

/// A mixin that provides reflection capabilities to a class.
///
/// This mixin adds [copyWith] and [toJson] functionality using platform channels
/// to communicate with native code.
///
/// Example usage:
/// ```dart
/// @Subzero.meta('Person', ['name', 'age'])
/// class Person with SubzeroEntity {
///   final String name;
///   final int age;
///
///   Person({required this.name, required this.age});
/// }
/// ```
/// An annotation that defines class name and property list
mixin SubzeroEntity<T> {
  static const MethodChannel _channel =
      MethodChannel('com.shinriyo.subzero.reflection');

  /// Returns the metadata for this entity
  Map<String, dynamic> get currentState;

  Future<T> copyWith<T>(Map<String, dynamic> properties) async {
    // Create a new map with current state
    final updatedState = Map<String, dynamic>.from(currentState);
    // Apply only the provided properties
    updatedState.addAll(properties);

    final result = await _channel.invokeMethod('copyWithModel', {
      'properties': updatedState,
      'currentState': currentState,
    });

    if (result is Map) {
      return Map<String, dynamic>.from(result) as T;
    }
    return result as T;
  }

  Future<T> toJson<T>() async {
    final result = await _channel.invokeMethod('toJson', {
      'properties': currentState,
    });

    if (result is Map) {
      return Map<String, dynamic>.from(result) as T;
    }
    return result as T;
  }
}
