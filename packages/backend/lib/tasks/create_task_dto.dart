// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateTaskDto {
  const CreateTaskDto({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  factory CreateTaskDto.fromMap(Map<String, dynamic> map) {
    return CreateTaskDto(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  factory CreateTaskDto.fromJson(String source) =>
      CreateTaskDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
