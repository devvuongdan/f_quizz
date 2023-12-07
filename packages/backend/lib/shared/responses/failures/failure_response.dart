// ignore_for_file: overridden_fields

import 'package:backend/shared/responses/responsef.dart';
import 'package:backend/shared/responses/resultf.dart';

///
class FailureResult extends ResultF {
  ///
  const FailureResult({
    required super.message,
  }) : super(ok: false);
  @override
  String toString() => 'FailureResult(message: $message)';
}

///
class FailureResponse extends ResponseF {
  ///
  const FailureResponse({
    required super.time,
    required this.result,
    required super.code,
  }) : super(
          data: null,
          result: result,
        );

  ///
  @override
  final FailureResult result;
}
