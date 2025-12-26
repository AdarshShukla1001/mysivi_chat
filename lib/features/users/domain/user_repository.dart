import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/features/users/data/models/user_entity.dart';

abstract class UserRepository {
  Future<DataState<List<UserEntity>>> getUsers();
  Future<DataState<void>> addUser(String name, String id, String lastActive);
}
