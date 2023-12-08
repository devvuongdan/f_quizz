// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateUserByEmailDto {
  const CreateUserByEmailDto({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  factory CreateUserByEmailDto.fromMap(Map<String, dynamic> map) {
    return CreateUserByEmailDto(
      username: map['email'] as String,
      password: map['password'] as String,
    );
  }

  factory CreateUserByEmailDto.fromJson(String source) =>
      CreateUserByEmailDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
