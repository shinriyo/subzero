import 'package:flutter/services.dart';

/// A mixin that provides reflection capabilities to a class.
///
/// This mixin adds [copyWith] and [toJson] functionality using platform channels
/// to communicate with native code.
///
/// Example usage:
/// ```dart
/// @SubzeroClass('Person')
/// class Person with SubzeroEntity {
///   @SubzeroProperty('name')
///   final String name;
///
///   @SubzeroProperty('age')
///   final int age;
///
///   Person({required this.name, required this.age});
/// }
/// ```
/// クラス名とプロパティリストを定義するアノテーション
mixin SubzeroEntity {
  static const MethodChannel _channel =
      MethodChannel('com.shinriyo.subzero.reflection');

  // 現在のオブジェクトの状態をMapとして返す
  Map<String, dynamic> get currentState;

  Future<T> copyWith<T>(Map<String, dynamic> properties) async {
    // 現在の全プロパティの値を取得
    final currentValues = currentState;

    // 更新したいプロパティで上書き
    final updatedProperties = {
      ...currentValues, // 既存の値を展開
      ...properties, // 更新したい値で上書き
    };

    final result = await _channel.invokeMethod('copyWithModel', {
      'properties': updatedProperties, // 全プロパティの値を送信
      'className': runtimeType.toString(),
    });

    return result as T;
  }

  Future<Map<String, dynamic>> toJson() async {
    final result = await _channel.invokeMethod('toJson', {
      'className': runtimeType.toString(),
      'properties': currentState, // 現在の状態を送信
    });

    return Map<String, dynamic>.from(result);
  }
}
