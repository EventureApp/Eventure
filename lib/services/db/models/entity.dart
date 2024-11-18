abstract class Entity {
  Map<String, dynamic> toMap();

  factory Entity.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}
