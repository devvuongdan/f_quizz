import 'dart:io';

import 'package:backend/shared/responses/failures/failure_response.dart';

///
class BadRequestResponse extends FailureResponse {
  ///
  const BadRequestResponse({
    required super.time,
    required super.result,
  }) : super(code: HttpStatus.badRequest);

  @override
  String toString() =>
      'BadRequestResponse(time: $time, result: $result, code: $code)';
}
