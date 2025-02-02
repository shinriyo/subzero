/// An annotation that defines the class name and its property list.
/// Used to provide metadata for reflection purposes.
/// Example usage:
/// ```dart
/// @Subzero.meta('Person', ['name', 'age'])
/// class Person with SubzeroEntity {
///   final String name;
///   final int age;
///
///   Person({required this.name, required this.age});
/// }
/// ```
/// Subzero annotations for reflection metadata
class Subzero {
  /// Defines class name and property list for reflection
  const factory Subzero.meta(String name, List<String> properties) =
      SubzeroMeta;
}

/// Implementation class for @Subzero.meta annotation
class SubzeroMeta implements Subzero {
  final String name;
  final List<String> properties;
  const SubzeroMeta(this.name, this.properties);
}
