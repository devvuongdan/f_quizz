import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class ModelF {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ModelF({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ModelF.fromMap(
    Map<String, dynamic> map,
  ) {
    throw UnimplementedError();
  }

  @override
  String toString() =>
      'ModelF(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant ModelF other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => id.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;

  String toJson() => json.encode(toMap());

  factory ModelF.fromJson(String source) =>
      ModelF.fromMap(json.decode(source) as Map<String, dynamic>);
}
