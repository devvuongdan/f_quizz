// ignore_for_file: no_default_cases

import 'package:backend/shared/responses/failures/failure_response.dart';
import 'package:backend/shared/responses/failures/method_not_allowed_response.dart';
import 'package:backend/shared/responses/success_response.dart';
import 'package:backend/tasks/create_task_dto.dart';
import 'package:backend/tasks/task_data_source.dart';
import 'package:backend/tasks/task_dto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/tasks/taskf.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _onPost(context);
    case HttpMethod.get:
      return _onGet(context);

    default:
      final err =
          MethodNotAllowedResponse(time: DateTime.now().toIso8601String());
      return Response.json(
        statusCode: err.code,
        body: err.toMap(),
      );
  }
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<TaskDataSource>();
  final body = await context.request.body();
  final createTaskDto = CreateTaskDto.fromJson(body);
  final result = await repo.createTask(createTaskDto);
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

Future<Response> _onGet(RequestContext context) async {
  final repo = context.read<TaskDataSource>();
  // final body = await context.request.body();
  // final createTaskDto = CreateTaskDto.fromJson(body);
  final result = await repo.getListTaskByParam();
  if (result is Right<FailureResponse, List<TaskF>>) {
    final dataList = result.right.map((e) {
      return TaskDto(
        id: e.id,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        status: e.status,
        title: e.title,
        description: e.description,
      );
    }).toList();
    final res = SuccessResponseList<TaskDto>(
      dataList: dataList,
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
