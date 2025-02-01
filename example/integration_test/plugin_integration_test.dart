import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:subzero_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test copyWith and toJson methods', (WidgetTester tester) async {
    // `Person`オブジェクトを作成
    Person person = Person(name: 'Alice', age: 30);

    // `copyWith`を使ってプロパティを変更
    var updatedPerson = await person.copyWith({
      'name': 'Bob',
      'age': 35,
    });

    // 更新された`Person`オブジェクトをJSONに変換
    var updatedJson = await updatedPerson.toJson();

    // 更新された名前と年齢が正しく反映されているか確認
    expect(updatedJson['name'], 'Bob');
    expect(updatedJson['age'], 35);
  });
}
