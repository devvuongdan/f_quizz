// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared/models/modelf.dart';

class TaskF extends ModelF {
  const TaskF({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.title,
    required this.description,
    required this.status,
  });

  final String title;
  final String description;
  final int status;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'status': status,
    };
  }

  factory TaskF.fromMap(Map<String, dynamic> map) {
    return TaskF(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      title: map['title'] as String,
      description: map['description'] as String,
      status: map['status'] as int,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory TaskF.fromJson(String source) =>
      TaskF.fromMap(json.decode(source) as Map<String, dynamic>);
}
