import 'package:mysivi_chat/core/database/app_database.dart';
import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/features/users/data/models/user_entity.dart';
import 'package:mysivi_chat/services/user_db_service/user_db_service.dart';

class UserDbServiceImpl implements UserDbService {
  UserDbServiceImpl();

  @override
  Future<DataState<void>> insertUser(UserEntity user) async {
    try {
      final database = await AppDatabase.database;
      await database.insert('users', user.toMap());
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<DataState<List<UserEntity>>> getUsers() async {
    try {
      final database = await AppDatabase.database;
      final res = await database.query('users');
      return DataSuccess(res.map(UserEntity.fromMap).toList());
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> updateLastActive(String userId) async {
    try {
      final database = await AppDatabase.database;
      await database.update(
        'users',
        {'last_active': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userId],
      );
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }
}
