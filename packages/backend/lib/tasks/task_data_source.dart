// ignore_for_file: public_member_api_docs, sort_constructors_first, missing_whitespace_between_adjacent_strings, lines_longer_than_80_chars
import 'package:backend/shared/responses/failures/failure_response.dart';
import 'package:backend/shared/responses/failures/internal_server_error_response.dart';
import 'package:backend/tasks/create_task_dto.dart';
import 'package:either_dart/either.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/models/tasks/taskf.dart';
import 'package:uuid/uuid.dart';

///
abstract class TaskDataSource {
  ///
  Future<Either<FailureResponse, List<TaskF>>> getListTaskByParam({
    Map<String, dynamic> querryParam = const {},
  });

  ///
  Future<Either<FailureResponse, TaskF>> getTaskByID(String id);

  ///
  Future<Either<FailureResponse, TaskF>> createTask(
    CreateTaskDto createTaskDto,
  );

  ///
  Future<Either<FailureResponse, TaskF>> updateTask(TaskF task);

  ///
  Future<Either<FailureResponse, bool>> deleteTaskByID(String id);
}

class TaskDataSourceImpl implements TaskDataSource {
  static const tableName = 'tasks';
  TaskDataSourceImpl();

  @override
  Future<Either<FailureResponse, List<TaskF>>> getListTaskByParam({
    Map<String, dynamic> querryParam = const {},
  }) async {
    // final now = DateTime.now();
    // try {
    //   await _createTable();

    //   await db.conn.execute(
    //     'INSERT INTO $tableName (id, createdAt, updatedAt, title, description, status) VALUES (\$1, \$2, \$3, \$4, \$5, \$6)',
    //     parameters: [
    //       newTask.id,
    //       newTask.createdAt.toIso8601String(),
    //       newTask.updatedAt.toIso8601String(),
    //       newTask.title,
    //       newTask.description,
    //       newTask.status,
    //     ],
    //   );

    //   await db.conn.close();
    //   return Right(newTask);
    // } catch (e) {
    //   print(e);
    //   return Left(
    //     InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
    //   );
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<FailureResponse, TaskF>> getTaskByID(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<FailureResponse, TaskF>> createTask(
    CreateTaskDto createTaskDto,
  ) async {
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
      await _createTable(conn: conn);
      final now = DateTime.now();
      final newTask = TaskF(
        id: const Uuid().v4(),
        createdAt: now,
        updatedAt: now,
        status: -1,
        title: createTaskDto.title,
        description: createTaskDto.description,
      );

      await conn.execute(
        'INSERT INTO $tableName (id, createdAt, updatedAt, title, description, status) VALUES (\$1, \$2, \$3, \$4, \$5, \$6)',
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
    } catch (e) {
      // print(e);
      return Left(
        InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, bool>> deleteTaskByID(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<FailureResponse, TaskF>> updateTask(TaskF task) async {
    throw UnimplementedError();
  }

  Future<Result> _createTable({required Connection conn}) async {
    final res = await conn.execute('CREATE TABLE IF NOT EXISTS $tableName ('
        '  id TEXT NOT NULL, '
        '  status INTEGER NOT NULL DEFAULT -1, '
        '  createdAt TEXT NOT NULL, '
        '  updatedAt TEXT NOT NULL, '
        '  title TEXT NOT NULL, '
        '  description TEXT NOT NULL '
        ')');

    return res;
  }
}
