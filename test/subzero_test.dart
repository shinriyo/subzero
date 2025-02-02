import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:subzero/annotations.dart';
import 'package:subzero/subzero_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.shinriyo.subzero.reflection');
  final log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'copyWithModel':
            return methodCall.arguments['properties'] as Map<String, dynamic>;
          case 'toJson':
            return <String, dynamic>{'name': 'test', 'age': 25};
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    log.clear();
  });

  test('copyWith sends correct data to platform channel', () async {
    final person = TestPerson(name: 'Alice', age: 30);
    final properties = <String, dynamic>{'name': 'Bob', 'age': 35};

    await person.copyWith(properties);

    expect(log, hasLength(1));
    expect(log.first.method, 'copyWithModel');
    expect(log.first.arguments['className'], 'Person');
    expect(log.first.arguments['properties'], properties);
    expect(log.first.arguments['propertyList'], ['name', 'age']);
  });

  test('toJson sends correct data to platform channel', () async {
    final person = TestPerson(name: 'Alice', age: 30);

    final json = await person.toJson();

    expect(log, hasLength(1));
    expect(log.first.method, 'toJson');
    expect(log.first.arguments['className'], 'Person');
    expect(log.first.arguments['propertyList'], ['name', 'age']);
    expect(json, <String, dynamic>{'name': 'test', 'age': 25});
  });
}

@Subzero.meta('Person', ['name', 'age'])
class TestPerson with SubzeroEntity {
  final String name;
  final int age;

  TestPerson({required this.name, required this.age});

  @override
  Map<String, dynamic> get currentState => {
        'name': name,
        'age': age,
      };
}
