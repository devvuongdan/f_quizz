// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:backend/shared/responses/dataf.dart';
import 'package:backend/shared/responses/resultf.dart';

class ResponseF<T extends DataF> {
  final String time;
  final int code;
  final ResultF result;
  final T? data;
  const ResponseF({
    required this.time,
    required this.result,
    required this.code,
    this.data,
  });

  @override
  String toString() =>
      'ResponseF(time: $time, result: $result, code: $code, data: $data)';

  ResponseF<T> copyWith({
    String? time,
    ResultF? result,
    T? data,
  }) {
    return ResponseF<T>(
      time: time ?? this.time,
      result: result ?? this.result,
      code: code,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'result': result.toMap(),
      'data': data?.toMap(),
      'time': time,
    };
  }

  factory ResponseF.fromMap(
    Map<String, dynamic> map, {
    required T Function(Map<String, dynamic> mapT) fromMapT,
  }) {
    return ResponseF<T>(
      time: map['time'] as String,
      code: map['code'] as int,
      result: ResultF.fromMap(map['result'] as Map<String, dynamic>),
      data: map['data'] != null
          ? fromMapT(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseF.fromJson(
    String source, {
    required T Function(Map<String, dynamic> mapT) fromMapT,
  }) =>
      ResponseF.fromMap(
        json.decode(source) as Map<String, dynamic>,
        fromMapT: fromMapT,
      );
}
