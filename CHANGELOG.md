## 0.0.3

### Features
- Added support for nested structures in data serialization
  - Now properly handles nested `SubzeroEntity` objects
  - Supports complex object hierarchies (e.g., Person with Address)
  - Improved serialization of custom classes

### Improvements
- Enhanced error handling by replacing print statements with proper error handling
- Cleaned up code documentation
- Improved type safety in serialization process

### Breaking Changes
None

## 0.0.2

* 🔧 Breaking Changes:
  - Changed property definition from `fields` to `properties`
  - New `properties` getter now includes both value and type information
* 🐛 Bug Fixes:
  - Removed hardcoded property access in native implementations
  - Fixed property retention in copyWith operations

Before:
```dart
@override
Map<String, Type> get fields => {
  'name': String,
  'age': int,
  'isActive': bool,
};
```

After:
```dart
@override
Map<String, ({dynamic value, Type type})> get properties => {
  'name': (value: name, type: String),
  'age': (value: age, type: int),
  'isActive': (value: isActive, type: bool),
};
```

## 0.0.1

* Initial release 🎉
* Features:
  - Runtime property type information
  - Automatic copyWith implementation
  - No code generation required
  - Platform-specific native code support (iOS and Android)
  - Zero build time impact
* Added support for:
  - Dynamic property access
  - Type-safe property mapping
  - Native platform implementations for iOS and Android
