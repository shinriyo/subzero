import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:subzero_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test copyWith and toJson methods', (WidgetTester tester) async {
    // Create Person object
    Person person = Person(name: 'Alice', age: 30, isActive: true);

    // Update properties using copyWith
    var updatedPerson = await person.copyWith({
      'name': 'Bob',
      'age': 35,
    });

    // Convert updated Person object to JSON
    var updatedJson = await updatedPerson.toJson();

    // Verify that name and age are updated correctly
    expect(updatedJson['name'], 'Bob');
    expect(updatedJson['age'], 35);
  });
}
