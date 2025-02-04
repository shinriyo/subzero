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

  dynamic _serializeValue(dynamic value) {
    if (value == null) return null;

    if (value is SubzeroEntity) {
      return _processNestedStructures(value.toMap());
    } else if (value is SubzeroSerializable) {
      return value.toJson();
    } else if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _serializeValue(v)));
    } else if (value is List) {
      return value.map((v) => _serializeValue(v)).toList();
    } else if (value is Set) {
      return value.map((v) => _serializeValue(v)).toList();
    } else if (_isBasicType(value)) {
      return value;
    }

    // For custom classes, return null or consider setting an appropriate fallback value
    return null;
  }

  bool _isBasicType(dynamic value) {
    return value is String ||
        value is num ||
        value is bool ||
        value is DateTime; // DateTime is treated as a basic type
  }

  Map<String, dynamic> toMap() {
    return properties
        .map((key, prop) => MapEntry(key, _serializeValue(prop.value)));
  }

  Future<T> copyWith<T>(Map<String, dynamic> properties) async {
    try {
      final currentValues = toMap();

      // Convert properties to appropriate format
      final processedProperties = _processNestedStructures(properties);

      final result = await _channel.invokeMethod('copyWithModel', {
        'data': processedProperties,
        'current': currentValues,
        'type': runtimeType.toString(),
        'fields': this
            .properties
            .map((key, prop) => MapEntry(key, prop.type.toString())),
      });

      if (result is Map) {
        final typedResult = Map<String, dynamic>.from(result);

        // Rebuild nested structures
        properties.forEach((key, value) {
          if (value is SubzeroEntity) {
            final propInfo = this.properties[key];
            if (propInfo != null && typedResult.containsKey(key)) {
              typedResult[key] = _processNestedStructures(value.toMap());
            }
          }
        });

        return typedResult as T;
      }
      throw StateError('Expected Map result from native code');
    } catch (e) {
      // In case of error, process the properties directly
      final processed = _processNestedStructures(properties);
      return processed as T;
    }
  }

  Future<T> toJson<T>() async {
    try {
      final data = toMap();
      final processedData = _processNestedStructures(data);
      return processedData as T;
    } catch (e) {
      // Instead of using print, throw a more specific error
      throw FormatException('Failed to convert to JSON: ${e.toString()}');
    }
  }

  Map<String, dynamic> _processNestedStructures(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is SubzeroEntity) {
        // SubzeroEntityの場合は再帰的に処理
        return MapEntry(key, _processNestedStructures(value.toMap()));
      } else if (value is Map) {
        return MapEntry(
            key, _processNestedStructures(value as Map<String, dynamic>));
      } else if (value is List) {
        return MapEntry(
            key,
            value.map((v) {
              if (v is SubzeroEntity) {
                return _processNestedStructures(v.toMap());
              } else if (v is Map) {
                return _processNestedStructures(v as Map<String, dynamic>);
              }
              return v;
            }).toList());
      }
      return MapEntry(key, value);
    });
  }
}

/// Implement this interface for custom class serialization
abstract class SubzeroSerializable {
  Map<String, dynamic> toJson();
  static SubzeroSerializable fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
