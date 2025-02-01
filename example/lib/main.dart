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
                  // Personオブジェクトを作成
                  Person person = Person(name: 'Alice', age: 30);

                  // copyWithを呼び出してプロパティを更新
                  var updatedPerson = await person.copyWith({
                    'name': 'Bob',
                    'age': 35,
                  });

                  // 更新後のPersonオブジェクトを表示
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
                  // Personオブジェクトを作成
                  Person person = Person(name: 'Charlie', age: 40);

                  // toJsonを呼び出してJSONに変換
                  var json = await person.toJson();

                  // JSONを表示
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

// Personクラスを定義
class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  // copyWithメソッドをプラグイン経由で呼び出す
  Future<Person> copyWith(Map<String, dynamic> properties) async {
    final result = await Subzero.copyWith('Person', properties);
    return Person(
      name: result['name'],
      age: result['age'],
    );
  }

  // toJsonメソッドをプラグイン経由で呼び出す
  Future<Map<String, dynamic>> toJson() async {
    return await Subzero.toJson('Person', {
      'name': name,
      'age': age,
    });
  }
}
