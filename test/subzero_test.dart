import 'package:flutter_test/flutter_test.dart';
import 'package:subzero/subzero.dart';
import 'package:subzero/subzero_platform_interface.dart';
import 'package:subzero/subzero_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSubzeroPlatform
    with MockPlatformInterfaceMixin
    implements SubzeroPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SubzeroPlatform initialPlatform = SubzeroPlatform.instance;

  test('$MethodChannelSubzero is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSubzero>());
  });

  test('getPlatformVersion', () async {
    Subzero subzeroPlugin = Subzero();
    MockSubzeroPlatform fakePlatform = MockSubzeroPlatform();
    SubzeroPlatform.instance = fakePlatform;

    expect(await subzeroPlugin.getPlatformVersion(), '42');
  });
}
