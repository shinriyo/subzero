# ❄️ Subzero

A lightning-fast Flutter plugin that provides reflection capabilities for Dart classes. No code generation, no build time impact!

## 🚀 Why Subzero?

Inspired by [freezed](https://pub.dev/packages/freezed), but with a twist:

- **Zero Build Time** ⚡ - No code generation needed
- **Runtime Magic** 🎩 - Uses native platform implementations
- **Simple API** 💫 - Just mix in and go!

The name? Just as freezed "freezes" your classes with generated code, Subzero achieves similar functionality but at a "lower temperature" - without the build step! Cool, right? 🧊

## ✨ Features

- 🔄 Runtime property type information
- 📝 Automatic copyWith implementation
- 🏃‍♂️ No code generation required
- 🛠 No build_runner dependency
- 📱 Platform-specific native code support (iOS and Android)
- ⚡ Zero build time impact

## 📦 Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  subzero: ^0.0.2
```

## 💻 Usage

### Define your class

```dart
class Person with SubzeroEntity {
  final String name;
  final int age;
  final bool isActive;

  Person({
    required this.name,
    required this.age,
    this.isActive = false,
  });

  @override
  Map<String, ({dynamic value, Type type})> get properties => {
    'name': (value: name, type: String),
    'age': (value: age, type: int),
    'isActive': (value: isActive, type: bool),
  };
}
```

### Use copyWith

```dart
void main() async {
  final person = Person(name: 'Bob', age: 35);
  
  // Create a copy with modified properties
  final updatedPerson = await person.copyWith({
    'name': 'Alice',
    'age': 25,
  });
}
```

## 🏗 Platform-specific code

<details>
<summary>iOS (Swift)</summary>

```swift
public class SubzeroPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.shinriyo.subzero.reflection", 
                                     binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SubzeroPlugin(), channel: channel)
  }
}
```
</details>

<details>
<summary>Android (Kotlin)</summary>

```kotlin
class SubzeroPlugin: FlutterPlugin, MethodCallHandler {
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "copyWithModel" -> {
        // Implementation details
      }
    }
  }
}
```
</details>

## 🤝 Contributing

Feel free to contribute to this project:

1. Fork it
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ❤️ Support

Like this project? Please give it a star ⭐️ to show your support!

