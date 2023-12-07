// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:backend/shared/responses/dataf.dart';

class TaskDto extends DataF {
  TaskDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.status,
  });

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

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String description;
  final int status;

  @override
  String toJson() => json.encode(toMap());
}
