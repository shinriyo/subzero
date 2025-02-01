import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:subzero/subzero_entiry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set up mock method channel
  const channel = MethodChannel('com.shinriyo.subzero.reflection');
  final log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        log.add(methodCall);
        // Mock responses based on method calls
        switch (methodCall.method) {
          case 'copyWithModel':
            final args = methodCall.arguments as Map;
            final props = args['properties'] as Map;
            return {
              ...props,
              'name': props['name'] ?? 'default',
              'age': props['age'] ?? 0,
            };
          case 'toJson':
            return {'name': 'John', 'age': 30};
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    log.clear();
  });

  // Test copyWith functionality
  test('copyWith should update properties correctly', () async {
    final person = Person(name: 'John', age: 30);
    final result = await person.copyWith<Person>({'name': 'Jane'});

    // Verify method channel call
    expect(log, hasLength(1));
    expect(log.first.method, 'copyWithModel');

    // Verify the returned properties
    expect(result.name, 'Jane');
    expect(result.age, 30);
  });

  // Test toJson functionality
  test('toJson should return properties as map', () async {
    final person = Person(name: 'John', age: 30);
    final json = await person.toJson();

    // Verify method channel call
    expect(log, hasLength(1));
    expect(log.first.method, 'toJson');

    // Verify the returned map
    expect(json, isA<Map<String, dynamic>>());
    expect(json.containsKey('name'), true);
    expect(json.containsKey('age'), true);
  });
}

// Test Person class implementation
class Person with SubzeroEntiry {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  @override
  String get className => 'Person';
}
