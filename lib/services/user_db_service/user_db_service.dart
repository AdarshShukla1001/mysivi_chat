import '../../../core/resources/data_state.dart';
import '../../../features/users/data/models/user_entity.dart';

abstract class UserDbService {
  Future<DataState<void>> insertUser(UserEntity user);
  Future<DataState<List<UserEntity>>> getUsers();
  Future<DataState<void>> updateLastActive(String userId);
}
