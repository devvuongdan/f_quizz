// ignore_for_file: avoid_unused_constructor_parameters

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class DataF<T extends Object> {
  DataF();
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

  factory DataF.fromMap(
    Map<String, dynamic> map, {
    required T Function(Map<String, dynamic> mapT) fromMapT,
  }) {
    throw UnimplementedError();
  }

  String toJson() => json.encode(toMap());

  factory DataF.fromJson(
    String source, {
    required T Function(Map<String, dynamic> mapT) fromMapT,
  }) =>
      DataF.fromMap(
        json.decode(source) as Map<String, dynamic>,
        fromMapT: fromMapT,
      );
}
