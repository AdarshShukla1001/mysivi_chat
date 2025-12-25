import '../domain/user_model.dart';

class UserRepository {
  final List<UserModel> _users = [];

  Future<List<UserModel>> getUsers() async {
    return List.from(_users);
  }

  Future<void> addUser(UserModel user) async {
    _users.add(user);
  }
}
