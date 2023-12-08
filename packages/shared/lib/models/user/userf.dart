// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared/models/modelf.dart';

class UserF extends ModelF {
  const UserF({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.username,
    required this.hashedPw,
    required this.updatedPwAt,
    required this.status,
  });

  final String username;
  final String hashedPw;
  final DateTime updatedPwAt;
  final int status;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'username': username,
      'hashed_pw': hashedPw,
      'updated_pw_at': updatedPwAt.toIso8601String(),
      'status': status,
    };
  }

  factory UserF.fromMap(Map<String, dynamic> map) {
    return UserF(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      username: map['username'] as String,
      hashedPw: map['hashed_pw'] as String,
      updatedPwAt: DateTime.parse(map['updated_pw_at'] as String),
      status: map['status'] as int,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserF.fromJson(String source) =>
      UserF.fromMap(json.decode(source) as Map<String, dynamic>);
}
