import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/user_repository.dart';
import '../../domain/user_model.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final users = await userRepository.getUsers();
    emit(UserLoaded(users));
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    final newUser = UserModel(id: const Uuid().v4(), name: event.name);
    await userRepository.addUser(newUser);
    final users = await userRepository.getUsers();
    emit(UserLoaded(users));
  }
}
