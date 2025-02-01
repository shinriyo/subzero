import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'subzero_method_channel.dart';

abstract class SubzeroPlatform extends PlatformInterface {
  /// Constructs a SubzeroPlatform.
  SubzeroPlatform() : super(token: _token);

  static final Object _token = Object();

  static SubzeroPlatform _instance = MethodChannelSubzero();

  /// The default instance of [SubzeroPlatform] to use.
  ///
  /// Defaults to [MethodChannelSubzero].
  static SubzeroPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SubzeroPlatform] when
  /// they register themselves.
  static set instance(SubzeroPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
