import 'package:backend/users/user_data_source.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(provider<UserDataSource>((_) => UserDataSourceImpl()));
}
