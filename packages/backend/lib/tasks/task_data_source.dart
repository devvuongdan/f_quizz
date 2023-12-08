// ignore_for_file: public_member_api_docs, sort_constructors_first, missing_whitespace_between_adjacent_strings, lines_longer_than_80_chars, omit_local_variable_types, avoid_print
import 'dart:convert';
import 'dart:math';

import 'package:backend/shared/responses/failures/failure_response.dart';
import 'package:backend/shared/responses/failures/internal_server_error_response.dart';
import 'package:backend/shared/responses/failures/notfound_response.dart';
import 'package:backend/tasks/create_task_dto.dart';
import 'package:backend/tasks/update_task_dto.dart';
import 'package:either_dart/either.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/models/tasks/taskf.dart';
import 'package:uuid/uuid.dart';

///
abstract class TaskDataSource {
  ///
  Future<Either<FailureResponse, List<TaskF>>> getListTaskByParam({
    int? limit,
    int? offset,
    String? query,
    int? status,
  });

  ///
  Future<Either<FailureResponse, TaskF>> getTaskByID(String id);

  ///
  Future<Either<FailureResponse, TaskF>> createTask(
    CreateTaskDto createTaskDto,
  );

  ///
  Future<Either<FailureResponse, TaskF>> updateTask(UpdateTaskDto task);

  ///
  Future<Either<FailureResponse, bool>> deleteTaskByID(String id);
}

class TaskDataSourceImpl implements TaskDataSource {
  static const tableName = 'tasks';
  TaskDataSourceImpl();

  @override
  Future<Either<FailureResponse, List<TaskF>>> getListTaskByParam({
    int? limit,
    int? offset,
    String? query,
    int? status,
  }) async {
    final now = DateTime.now();
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      await createTable(conn: conn);
      String execute = 'SELECT * FROM $tableName';

      if (query != null) {
        execute +=
            " WHERE title LIKE '%$query%' OR description LIKE '%$query%'";

        if (status != null) {
          execute += " AND status = '$status'";
        }
      } else {
        if (status != null) {
          execute += " WHERE status = '$status'";
        }
      }

      final Result result = await conn.execute(
        execute,
      );

      await conn.close();
      if (result.isEmpty) {
        return Left(NotFoundResponse(time: now.toIso8601String()));
      }

      final List<Map<String, dynamic>> data =
          result.map((element) => element.toColumnMap()).toList();

      final List<TaskF> taskList =
          data.map((e) => TaskF.fromJson(jsonEncode(e))).toList();

      //Phân trang
      final int start = offset == null ? 0 : min(taskList.length - 1, offset);
      final int end = limit == null
          ? taskList.length - 1
          : min(taskList.length - 1, start + limit);

      taskList.getRange(
        start,
        end,
      );

      return Right(taskList);
    } catch (e, stacktree) {
      print('Err $e, Stacktree $stacktree');
      return Left(
        InternalServerErrorResponse(time: now.toIso8601String()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, TaskF>> getTaskByID(String id) async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      await createTable(conn: conn);

      final result = await conn.execute(
        Sql.named('SELECT * FROM $tableName WHERE id=@id'),
        parameters: {'id': id},
      );
      await conn.close();
      if (result.isEmpty) {
        return Left(NotFoundResponse(time: DateTime.now().toIso8601String()));
      } else {
        final List<Map<String, dynamic>> data =
            result.map((element) => element.toColumnMap()).toList();
        final List<TaskF> taskList =
            data.map((e) => TaskF.fromJson(jsonEncode(e))).toList();

        await conn.close();

        return Right(
          taskList.first,
        );
      }
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, TaskF>> createTask(
    CreateTaskDto createTaskDto,
  ) async {
    final now = DateTime.now();
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      await createTable(conn: conn);

      final newTask = TaskF(
        id: const Uuid().v4(),
        createdAt: now,
        updatedAt: now,
        status: -1,
        title: createTaskDto.title,
        description: createTaskDto.description,
      );

      await conn.execute(
        'INSERT INTO $tableName (id, created_at, updated_at, title, description, status) VALUES (\$1, \$2, \$3, \$4, \$5, \$6)',
        parameters: [
          newTask.id,
          newTask.createdAt.toIso8601String(),
          newTask.updatedAt.toIso8601String(),
          newTask.title,
          newTask.description,
          newTask.status,
        ],
      );

      await conn.close();
      return Right(newTask);
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, bool>> deleteTaskByID(String id) async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final result = await conn.execute(
        Sql.named('SELECT * FROM $tableName WHERE id=@id'),
        parameters: {'id': id},
      );

      if (result.isNotEmpty) {
        await conn.execute(
          Sql.named('DELETE FROM $tableName WHERE id=@id'),
          parameters: {'id': id},
        );
        await conn.close();

        return const Right(true);
      } else {
        await conn.close();
        return Left(
          NotFoundResponse(time: DateTime.now().toIso8601String()),
        );
      }
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, TaskF>> updateTask(
    UpdateTaskDto updateTaskDto,
  ) async {
    final now = DateTime.now();
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final result = await conn.execute(
        Sql.named('SELECT * FROM $tableName WHERE id=@id'),
        parameters: {'id': updateTaskDto.id},
      );

      if (result.isEmpty) {
        await conn.close();
        return Left(NotFoundResponse(time: DateTime.now().toIso8601String()));
      } else {
        final TaskF task =
            TaskF.fromJson(jsonEncode(result.first.toColumnMap()));
        final newTask = TaskF(
          id: task.id,
          createdAt: task.createdAt,
          updatedAt: now,
          status: updateTaskDto.status,
          title: updateTaskDto.title,
          description: updateTaskDto.description,
        );
        await conn.execute(
          'UPDATE $tableName SET updated_at=\$2, title=\$3, description=\$4, status=\$5 WHERE id=\$1',
          parameters: [
            newTask.id,
            newTask.updatedAt.toIso8601String(),
            newTask.title,
            newTask.description,
            newTask.status,
          ],
        );
        await conn.close();
        return Right(newTask);
      }
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
      );
    }
  }

  ///docker run --detach --name postgres_f_quizz_test -p 127.0.0.1:5432:5432 -e POSTGRES_USER=user -e POSTGRES_DATABASE=database -e POSTGRES_PASSWORD=pass postgres

  Future<Result> createTable({required Connection conn}) async {
    final res = await conn.execute('CREATE TABLE IF NOT EXISTS $tableName ('
        '  id TEXT NOT NULL, '
        '  status INTEGER NOT NULL DEFAULT -1, '
        '  created_at TEXT NOT NULL, '
        '  updated_at TEXT NOT NULL, '
        '  title TEXT NOT NULL, '
        '  description TEXT NOT NULL '
        ')');

    return res;
  }
}
