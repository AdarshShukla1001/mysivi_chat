import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/features/users/data/models/user_entity.dart';
import 'package:mysivi_chat/features/users/domain/user_repository.dart';
import 'package:mysivi_chat/services/user_db_service/user_db_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDbService userService;

  UserRepositoryImpl(this.userService);

  @override
  Future<DataState<List<UserEntity>>> getUsers() async {
    final result = await userService.getUsers();
    return result; // already domain-safe
  }

  @override
  Future<DataState<void>> addUser(String name, String id, String lastActive) {
    return userService.insertUser(
      UserEntity(name: name, id: id, lastActive: lastActive),
    );
  }
}
