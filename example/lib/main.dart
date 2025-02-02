import 'package:flutter/material.dart';
import 'package:subzero/subzero_entity.dart';
import 'package:subzero/annotations.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Subzero Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Create Person object
                  Person person =
                      Person(name: 'Alice', age: 30, isActive: true);

                  // Call copyWith to update properties
                  var updatedPerson = await person.copyWith({
                    'name': 'Bob',
                    'age': 35,
                  });

                  // Display updated Person object
                  setState(() {
                    _copyWithResult = "Updated Person: $updatedPerson";
                  });
                },
                child: const Text('Run copyWith Example'),
              ),
              const SizedBox(height: 10),
              Text(_copyWithResult, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Create Person object
                  Person person =
                      Person(name: 'Charlie', age: 40, isActive: true);

                  // Convert to JSON using toJson
                  var json = await person.toJson();

                  // Display JSON
                  setState(() {
                    _jsonResult = "Person as JSON: $json";
                  });
                },
                child: const Text('Run toJson Example'),
              ),
              const SizedBox(height: 10),
              Text(_jsonResult, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

@Subzero.meta('Person', ['name', 'age', 'isActive'])
class Person with SubzeroEntity {
  final String name;
  final int age;
  final bool isActive;

  Person({
    required this.name,
    required this.age,
    required this.isActive,
  });

  @override
  Map<String, dynamic> get currentState => {
        'name': name,
        'age': age,
        'isActive': isActive,
      };
}
