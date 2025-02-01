import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'subzero_platform_interface.dart';

/// An implementation of [SubzeroPlatform] that uses method channels.
class MethodChannelSubzero extends SubzeroPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('subzero');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
