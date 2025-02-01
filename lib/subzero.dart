
import 'subzero_platform_interface.dart';

class Subzero {
  Future<String?> getPlatformVersion() {
    return SubzeroPlatform.instance.getPlatformVersion();
  }
}
