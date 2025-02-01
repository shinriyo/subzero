import Flutter
import UIKit

public class SwiftSubzeroPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.shinriyo.subzero.reflection", binaryMessenger: registrar.messenger())
        let instance = SwiftSubzeroPlugin()
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
              let className = arguments["className"] as? String,
              let properties = arguments["properties"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        // ここでリフレクションを使ってプロパティを操作
        var updatedProperties = properties
        updatedProperties["name"] = "Updated \(properties["name"] ?? "")"
        updatedProperties["age"] = (properties["age"] as? Int ?? 0) + 1

        result(updatedProperties)
    }

    private func handleToJson(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let properties = arguments["properties"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        // プロパティをそのままJSONとして返す
        result(properties)
    }
}