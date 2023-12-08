// ignore_for_file: no_default_cases

import 'package:backend/shared/responses/failures/failure_response.dart';
import 'package:backend/shared/responses/failures/method_not_allowed_response.dart';
import 'package:backend/shared/responses/success_response.dart';
import 'package:backend/tasks/task_data_source.dart';
import 'package:backend/tasks/task_dto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/tasks/taskf.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _onGet(context, id);
    case HttpMethod.patch:
      return _onPatch(context, id);
    case HttpMethod.delete:
      return _onDelete(context, id);

    default:
      final err =
          MethodNotAllowedResponse(time: DateTime.now().toIso8601String());
      return Response.json(
        statusCode: err.code,
        body: err.toMap(),
      );
  }
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<TaskDataSource>();
  final result = await repo.getTaskByID(id);
  if (result is Right<FailureResponse, TaskF>) {
    final taskDto = TaskDto(
      id: result.right.id,
      createdAt: result.right.createdAt,
      updatedAt: result.right.updatedAt,
      status: result.right.status,
      title: result.right.title,
      description: result.right.description,
    );
    final res = SuccessResponse<TaskDto>(
      data: taskDto,
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

Future<Response> _onPatch(RequestContext context, String id) async {
  return Response(body: 'Welcome to Dart Frog!');
}

Future<Response> _onDelete(RequestContext context, String id) async {
  return Response(body: 'Welcome to Dart Frog!');
}
