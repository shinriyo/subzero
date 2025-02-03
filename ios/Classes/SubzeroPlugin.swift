import Flutter
import UIKit

public class SubzeroPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.shinriyo.subzero.reflection", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SubzeroPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "copyWithModel":
      guard let args = call.arguments as? [String: Any],
            let data = args["data"] as? [String: Any],
            let current = args["current"] as? [String: Any],
            let fields = args["fields"] as? [String: String] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      
      var updatedData = current
      for (key, value) in data {
        updatedData[key] = value
      }
      
      result(updatedData)
      
    case "toJson":
      guard let args = call.arguments as? [String: Any],
            let data = args["data"] as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments must be a map", details: nil))
        return
      }
      result(data)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
