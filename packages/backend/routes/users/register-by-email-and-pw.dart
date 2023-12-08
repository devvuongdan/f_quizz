// ignore_for_file: no_default_cases

import 'package:backend/shared/responses/failures/failure_response.dart';
import 'package:backend/shared/responses/success_response.dart';
import 'package:backend/users/create_user_by_email_dto.dart';
import 'package:backend/users/user_data_source.dart';
import 'package:backend/users/user_dto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/user/userf.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _onPost(context);

    default:
      return Response(body: 'Welcome F Quizz!!!');
  }
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<UserDataSource>();
  final body = await context.request.body();
  final createUserDto = CreateUserByEmailDto.fromJson(body);
  final result = await repo.createUser(createUserDto);
  if (result is Right<FailureResponse, UserF>) {
    final userDto = UserDto(
      id: result.right.id,
      createdAt: result.right.createdAt,
      updatedAt: result.right.updatedAt,
      status: result.right.status,
      username: result.right.username,
      hashedPw: '',
      updatedPwAt: result.right.updatedPwAt,
      name: result.right.name,
      phone: result.right.phone,
    );
    final res = SuccessResponse<UserDto>(
      data: userDto,
      time: DateTime.now().toIso8601String(),
    );
    return Response.json(
      statusCode: res.code,
      body: res.toMap(),
    );
  } else {
    return Response.json(
      statusCode: result.left.code,
      body: result.left.toMap(),
    );
  }
}
