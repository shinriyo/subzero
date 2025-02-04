import 'package:flutter/material.dart';
import 'package:subzero/subzero.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _copyWithResult = '';
  String _jsonResult = '';

  Widget _buildCopyWithExample() {
    return Column(
      children: [
        // Title
        const Text(
          'copyWith',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // Original Person object with Address
        const Text(
          'Original: Person(name: Charlie, age: 40, address: Address(street: "123 Main St", city: "Boston"))',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                // Create initial Person object
                final address = Address(
                  street: '123 Main St',
                  city: 'Boston',
                );
                final person = Person(
                  name: 'Charlie',
                  age: 40,
                  address: address,
                );

                // Create new Address for update
                final newAddress = Address(
                  street: '456 Oak St',
                  city: 'New York',
                );

                // Update using copyWith
                var updated = await person.copyWith({
                  'name': 'Bob',
                  'age': 35,
                  'address': newAddress,
                });
                setState(() {
                  _copyWithResult = "Updated Person: $updated";
                });
              },
              child: const Text('Run'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _copyWithResult = '';
                });
              },
              child: const Text('Reset'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(_copyWithResult, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildToJsonExample() {
    return Column(
      children: [
        // Title
        const Text(
          'toJson',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // Original Person object
        const Text(
          'Original: Person(name: Charlie, age: 40, address: Address(street: "123 Main St", city: "Boston"))',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Create Address and Person objects
                final address = Address(
                  street: '123 Main St',
                  city: 'Boston',
                );
                final person = Person(
                  name: 'Charlie',
                  age: 40,
                  address: address,
                );

                // Convert to JSON using toJson
                var json = await person.toJson();
                // Display JSON
                setState(() {
                  _jsonResult = "Person as JSON: $json";
                });
              },
              child: const Text(
                'Run',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _jsonResult = '';
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(_jsonResult, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Subzero Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCopyWithExample(),
              const SizedBox(height: 20),
              _buildToJsonExample(),
            ],
          ),
        ),
      ),
    );
  }
}

class Address with SubzeroEntity {
  final String street;
  final String city;

  Address({
    required this.street,
    required this.city,
  });

  @override
  Map<String, ({dynamic value, Type type})> get properties => {
        'street': (value: street, type: String),
        'city': (value: city, type: String),
      };
}

class Person with SubzeroEntity {
  final String name;
  final int age;
  final Address address; // Class that implements SubzeroEntity

  Person({
    required this.name,
    required this.age,
    required this.address,
  });

  @override
  Map<String, ({dynamic value, Type type})> get properties => {
        'name': (value: name, type: String),
        'age': (value: age, type: int),
        'address': (value: address, type: Address),
      };
}
