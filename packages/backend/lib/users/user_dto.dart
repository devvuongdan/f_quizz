// ignore_for_file: public_member_api_docs
import 'dart:convert';

import 'package:backend/shared/responses/dataf.dart';

class UserDto extends DataF {
  UserDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.hashedPw,
    required this.updatedPwAt,
    required this.status,
    required this.name,
    required this.phone,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: map['id'].toString(),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      username: map['title'] as String,
      hashedPw: map['hashed_pw'] as String,
      updatedPwAt: DateTime.parse(map['updated_pw_at'] as String),
      status: map['status'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }

  factory UserDto.fromJson(String source) =>
      UserDto.fromMap(json.decode(source) as Map<String, dynamic>);

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String username;
  final String hashedPw;
  final DateTime updatedPwAt;
  final int status;
  final String name;
  final String phone;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'title': username,
      'hashed_pw': hashedPw,
      'updated_pw_at': updatedPwAt.toIso8601String(),
      'status': status,
      'name': name,
      'phone': phone,
    };
  }

  String toJson() => json.encode(toMap());
}
