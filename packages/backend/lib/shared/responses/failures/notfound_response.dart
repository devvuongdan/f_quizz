import 'dart:io';

import 'package:backend/shared/responses/failures/failure_response.dart';

///
class NotFoundResponse extends FailureResponse {
  ///
  const NotFoundResponse({
    required super.time,
    super.result = const FailureResult(message: 'Not Found!'),
  }) : super(code: HttpStatus.notFound);

  @override
  String toString() =>
      'NotFoundResponse(time: $time, result: $result, code: $code)';
}

///
class NotFoundException implements Exception {}
