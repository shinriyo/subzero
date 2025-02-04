import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subzero/subzero.dart';

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
            return {
              'name': 'Bob',
              'age': 35,
              'address': {'street': 'Oak St', 'city': 'New York'}
            };
          case 'toJson':
            return {
              'name': 'test',
              'age': 25,
              'address': {'street': 'Main St', 'city': 'Boston'}
            };
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
    expect(log.first.arguments['type'], 'TestPerson');
    expect(log.first.arguments['data'], properties);
    expect(
      log.first.arguments['fields'],
      {'name': 'String', 'age': 'int'},
    );
  });

  test('toJson returns correct data structure', () async {
    final person = TestPerson(name: 'Alice', age: 30);

    final json = await person.toJson();

    expect(
      json,
      {
        'name': 'Alice',
        'age': 30,
      },
    );
  });

  test('toJson handles nested objects correctly', () async {
    final address = TestAddress(street: 'Main St', city: 'Boston');
    final person = TestPersonWithAddress(
      name: 'Alice',
      age: 30,
      address: address,
    );

    final json = await person.toJson();

    expect(
      json,
      {
        'name': 'Alice',
        'age': 30,
        'address': {'street': 'Main St', 'city': 'Boston'}
      },
    );
  });

  test('copyWith handles nested objects correctly', () async {
    final originalAddress = TestAddress(street: 'Main St', city: 'Boston');
    final person = TestPersonWithAddress(
      name: 'Alice',
      age: 30,
      address: originalAddress,
    );

    final newAddress = TestAddress(street: 'Oak St', city: 'New York');
    final properties = {
      'name': 'Bob',
      'age': 35,
      'address': newAddress,
    };

    await person.copyWith(properties);

    expect(log, hasLength(1));
    expect(log.first.method, 'copyWithModel');
    expect(log.first.arguments['type'], 'TestPersonWithAddress');
    expect(
      log.first.arguments['data'],
      {
        'name': 'Bob',
        'age': 35,
        'address': {'street': 'Oak St', 'city': 'New York'}
      },
    );
  });
}

class TestPerson with SubzeroEntity {
  final String name;
  final int age;

  TestPerson({required this.name, required this.age});

  @override
  Map<String, ({dynamic value, Type type})> get properties => {
        'name': (value: name, type: String),
        'age': (value: age, type: int),
      };
}

class TestAddress with SubzeroEntity {
  final String street;
  final String city;

  TestAddress({required this.street, required this.city});

  @override
  Map<String, ({dynamic value, Type type})> get properties => {
        'street': (value: street, type: String),
        'city': (value: city, type: String),
      };
}

class TestPersonWithAddress with SubzeroEntity {
  final String name;
  final int age;
  final TestAddress address;

  TestPersonWithAddress({
    required this.name,
    required this.age,
    required this.address,
  });

  @override
  Map<String, ({dynamic value, Type type})> get properties => {
        'name': (value: name, type: String),
        'age': (value: age, type: int),
        'address': (value: address, type: TestAddress),
      };
}
