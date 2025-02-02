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
      if let arguments = call.arguments as? [String: Any],
         let properties = arguments["properties"] as? [String: Any] {
        // プロパティをそのまま返す（値を保持）
        result(properties)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
      }
    case "toJson":
      if let arguments = call.arguments as? [String: Any] {
        // 現在のオブジェクトの状態を返す
        let currentState = arguments["properties"] as? [String: Any] ?? [:]
        result(currentState)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
