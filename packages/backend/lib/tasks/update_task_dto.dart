// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateTaskDto {
  const UpdateTaskDto({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });
  final String id;
  final String title;
  final String description;
  final int status;

  factory UpdateTaskDto.fromMap(Map<String, dynamic> map) {
    return UpdateTaskDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      status: map['status'] as int,
    );
  }

  factory UpdateTaskDto.fromJson(String source) =>
      UpdateTaskDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
