import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subzero/subzero.dart';

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
                  Person person = Person(name: 'Alice', age: 30);

                  // Call copyWith to update properties
                  var updatedPerson = await person.copyWith({
                    'name': 'Bob',
                    'age': 35,
                  });

                  // Display updated Person object
                  if (kDebugMode) {
                    print("Updated Person: ${await updatedPerson.toJson()}");
                  }
                  // => Updated Person: {name: Bob, age: 35}
                },
                child: Text('Run copyWith Example'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Create Person object
                  Person person = Person(name: 'Charlie', age: 40);

                  // Convert to JSON using toJson
                  var json = await person.toJson();

                  // Display JSON
                  if (kDebugMode) {
                    print("Person as JSON: $json");
                  }
                  // => Person as JSON: {name: Charlie, age: 40}
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

// Define Person class
class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  // Call copyWith method via plugin
  Future<Person> copyWith(Map<String, dynamic> properties) async {
    final result = await Subzero.copyWith('Person', properties);
    return Person(
      name: result['name'],
      age: result['age'],
    );
  }

  // Call toJson method via plugin
  Future<Map<String, dynamic>> toJson() async {
    return await Subzero.toJson('Person', {
      'name': name,
      'age': age,
    });
  }
}
