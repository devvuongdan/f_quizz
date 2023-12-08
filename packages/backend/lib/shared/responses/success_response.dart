// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:backend/shared/responses/dataf.dart';
import 'package:backend/shared/responses/responsef.dart';
import 'package:backend/shared/responses/resultf.dart';

///
class SuccessResponse<T extends DataF> extends ResponseF<T> {
  ///
  SuccessResponse({
    required super.time,
    required this.data,
  }) : super(result: const SuccessResult(), code: HttpStatus.ok);

  ///
  @override
  final T data;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'result': result.toMap(),
      'data': data.toMap(),
      'time': time,
    };
  }
}

///
class SuccessResponseList<T extends DataF> extends ResponseF<T> {
  ///
  SuccessResponseList({
    required super.time,
    required this.dataList,
  }) : super(result: const SuccessResult(), code: HttpStatus.ok);

  ///
  final List<T> dataList;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'result': result.toMap(),
      'data': dataList.map((e) => e.toMap()).toList(),
      'time': time,
    };
  }
}

///
class SuccessResult extends ResultF {
  ///
  const SuccessResult() : super(ok: true, message: 'Success');
}
