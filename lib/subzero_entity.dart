import 'package:flutter/services.dart';

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
mixin SubzeroEntity {
  static const MethodChannel _channel =
      MethodChannel('com.shinriyo.subzero.reflection');

  /// Returns the current object state as a Map
  Map<String, dynamic> get currentState;

  Future<T> copyWith<T>(Map<String, dynamic> properties) async {
    /// Get all current property values
    final currentValues = currentState;

    /// Create updated properties by merging current values with updates
    final updatedProperties = {
      /// Spread existing values
      ...currentValues,

      /// Override with update values
      ...properties,
    };

    final result = await _channel.invokeMethod('copyWithModel', {
      /// Send all property values
      'properties': updatedProperties,
      'className': runtimeType.toString(),
    });

    return result as T;
  }

  Future<Map<String, dynamic>> toJson() async {
    final result = await _channel.invokeMethod('toJson', {
      'className': runtimeType.toString(),

      /// Send current state
      'properties': currentState,
    });

    return Map<String, dynamic>.from(result);
  }
}
