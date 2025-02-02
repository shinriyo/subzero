import Flutter
import UIKit

public class SubzeroPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.shinriyo.subzero.reflection", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SubzeroPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("Method: \(call.method)")
    print("Raw arguments: \(String(describing: call.arguments))")
    
    switch call.method {
    case "copyWithModel":
      guard let args = call.arguments as? [String: Any],
            let data = args["data"] as? [String: Any],
            let type = args["type"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      
      print("Type string: \(type)")
      print("Received data: \(data)")
      
      // Keep the current data
      var updatedData = data
      
      // Parse annotation information
      let pattern = #"@Subzero\((.*?)\)"#
      if let regex = try? NSRegularExpression(pattern: pattern, options: []),
         let match = regex.firstMatch(in: type, options: [], range: NSRange(type.startIndex..<type.endIndex, in: type)),
         let annotationRange = Range(match.range(at: 1), in: type) {
        
        let annotation = String(type[annotationRange])
        print("Found annotation: \(annotation)")
        
        // Retrieve property information from annotation
        let propertyPattern = #"\{([^}]+)\}"#
        if let propRegex = try? NSRegularExpression(pattern: propertyPattern, options: []),
           let propMatch = propRegex.firstMatch(in: annotation, options: [], range: NSRange(annotation.startIndex..<annotation.endIndex, in: annotation)),
           let propsRange = Range(propMatch.range(at: 1), in: annotation) {
          
          let properties = String(annotation[propsRange])
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
          
          print("Found properties: \(properties)")
          
          // Process each property
          for prop in properties {
            let parts = prop.components(separatedBy: ":")
            if parts.count == 2 {
              let name = parts[0].trimmingCharacters(in: .whitespaces)
              if updatedData[name] == nil {
                let type = parts[1].trimmingCharacters(in: .whitespaces)
                switch type.lowercased() {
                case "string": updatedData[name] = ""
                case "int": updatedData[name] = 0
                case "bool": updatedData[name] = false
                default: updatedData[name] = nil
                }
              }
            }
          }
        }
      }
      
      print("Returning data: \(updatedData)")
      result(updatedData)
      
    case "toJson":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments must be a map", details: nil))
        return
      }
      result(args)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
