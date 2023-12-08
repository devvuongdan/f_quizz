// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'dart:convert';

import 'package:backend/shared/extensions/hash_ext.dart';
import 'package:backend/shared/responses/failures/bad_request_response.dart';
import 'package:backend/shared/responses/failures/failure_response.dart';
import 'package:backend/shared/responses/failures/internal_server_error_response.dart';
import 'package:backend/shared/responses/failures/notfound_response.dart';
import 'package:backend/users/create_user_by_email_dto.dart';
import 'package:either_dart/either.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/models/user/userf.dart';
import 'package:uuid/uuid.dart';

///
abstract class UserDataSource {
  Future<Either<FailureResponse, UserF>> createUser(
    CreateUserByEmailDto createUserDto,
  );

  Future<Either<FailureResponse, UserF>> getUserByUsername(
    String username,
  );
}

///

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl();

  ///
  static const tableName = 'user2';

  ///
  Future<Result> createTable({required Connection conn}) async {
    final res = await conn.execute('CREATE TABLE IF NOT EXISTS $tableName ('
        '  id TEXT NOT NULL, '
        '  created_at TEXT NOT NULL, '
        '  updated_at TEXT NOT NULL, '
        '  updated_pw_at TEXT NOT NULL, '
        '  username TEXT NOT NULL, '
        '  hashed_pw TEXT NOT NULL, '
        '  status INTEGER NOT NULL DEFAULT 0 '
        ')');

    return res;
  }

  @override
  Future<Either<FailureResponse, UserF>> createUser(
    CreateUserByEmailDto createUserDto,
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
      await createTable(conn: conn);
      final user = await getUserByUsername(
        createUserDto.username,
      );
      if (user is Left && user.left is NotFoundResponse) {
        final now = DateTime.now();
        final newUser = UserF(
          id: const Uuid().v4(),
          createdAt: now,
          updatedAt: now,
          username: createUserDto.username,
          hashedPw: createUserDto.password.hashValue,
          updatedPwAt: now,
          status: -1,
        );
        await conn.execute(
          'INSERT INTO $tableName (id, created_at, updated_at, username, hashed_pw, updated_pw_at, status) VALUES (\$1, \$2, \$3, \$4, \$5, \$6, \$7)',
          parameters: [
            newUser.id,
            newUser.createdAt.toIso8601String(),
            newUser.updatedAt.toIso8601String(),
            newUser.username,
            newUser.hashedPw,
            newUser.updatedPwAt.toIso8601String(),
            newUser.status,
          ],
        );
        return Right(newUser);
      } else if (user is Right) {
        return Left(
          BadRequestResponse(
            time: DateTime.now().toIso8601String(),
            result: const FailureResult(
              message: 'Bad Request! Username or email has been used!',
            ),
          ),
        );
      } else {
        return Left(
          InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
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
  Future<Either<FailureResponse, UserF>> getUserByUsername(
    String username,
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
      await createTable(conn: conn);
      final result = await conn.execute(
        Sql.named('SELECT * FROM $tableName WHERE username=@username'),
        parameters: {'username': username},
      );
      await conn.close();
      if (result.isEmpty) {
        return Left(
          NotFoundResponse(time: DateTime.now().toIso8601String()),
        );
      } else {
        final data = result.map((element) => element.toColumnMap()).toList();
        final userList =
            data.map((e) => UserF.fromJson(jsonEncode(e))).toList();
        return Right(userList.first);
      }
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        InternalServerErrorResponse(time: DateTime.now().toIso8601String()),
      );
    }
  }
}
