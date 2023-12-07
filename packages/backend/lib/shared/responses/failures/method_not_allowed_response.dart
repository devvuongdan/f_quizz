import 'dart:io';

import 'package:backend/shared/responses/failures/failure_response.dart';

///
class MethodNotAllowedResponse extends FailureResponse {
  ///
  const MethodNotAllowedResponse({
    required super.time,
    super.result = const FailureResult(message: 'Method Not Allowed!'),
  }) : super(code: HttpStatus.methodNotAllowed);

  @override
  String toString() =>
      'MethodNotAllowedResponse(time: $time, result: $result, code: $code)';
}
