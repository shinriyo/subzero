import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subzero/subzero_entity.dart';
import 'package:subzero/annotations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Subzero Example')),
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
                  if (kDebugMode) {
                    print("Updated Person: $updatedPerson");
                  }
                  // => Updated Person: {name: Bob, age: 35}
                },
                child: Text('Run copyWith Example'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Create Person object
                  Person person =
                      Person(name: 'Charlie', age: 40, isActive: true);

                  // Convert to JSON using toJson
                  var json = await person.toJson();

                  // Display JSON
                  if (kDebugMode) {
                    print("Person as JSON: $json");
                  }
                  // => Person PersonFactory implements ModelFactory<Person> { PersonFactory implements ModelFactory<Person> { as JSON: {name: Charlie, age: 40}
                },
                child: Text('Run toJson Example'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@SubzeroClass('Person', ['name', 'age', 'isActive'])
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
