import 'dart:io';

import 'package:backend/shared/responses/failures/failure_response.dart';

///
class InternalServerErrorResponse extends FailureResponse {
  ///
  const InternalServerErrorResponse({
    required super.time,
    super.result = const FailureResult(message: 'Internal Server Error!'),
  }) : super(code: HttpStatus.internalServerError);

  @override
  String toString() =>
      'InternalServerErrorResponse(time: $time, result: $result, code: $code)';
}
