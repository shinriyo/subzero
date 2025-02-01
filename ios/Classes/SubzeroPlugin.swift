import Flutter
import UIKit

public class SubzeroPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.shinriyo.subzero.reflection", binaryMessenger: registrar.messenger())
        let instance = SubzeroPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "copyWithModel":
            handleCopyWithModel(call, result: result)
        case "toJson":
            handleToJson(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleCopyWithModel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let properties = arguments["properties"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        // プロパティをそのまま返す
        result(properties)
    }

    private func handleToJson(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let properties = arguments["properties"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        // プロパティをそのまま返す
        result(properties)
    }
}