import 'package:backend/tasks/task_data_source.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(provider<TaskDataSource>((_) => TaskDataSourceImpl()));
}
