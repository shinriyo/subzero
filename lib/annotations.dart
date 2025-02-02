/// An annotation that defines the class name and its property list.
/// Used to provide metadata for reflection purposes.
/// Example usage:
/// ```dart
/// @SubzeroClass('Person', ['name', 'age'])
/// class Person with SubzeroEntity {
///   final String name;
///   final int age;
///
///   Person({required this.name, required this.age});
/// }
/// ```
class SubzeroClass {
  final String name;
  final List<String> properties;
  const SubzeroClass(this.name, this.properties);
}
