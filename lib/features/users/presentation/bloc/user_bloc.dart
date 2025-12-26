import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/features/users/data/models/user_entity.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service.dart';
import 'package:uuid/uuid.dart';
import '../../domain/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final MessageDbService messageDb;
  StreamSubscription? _messageSubscription;

  UserBloc(this.userRepository, this.messageDb) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);

    _messageSubscription = messageDb.messageStream.listen((_) {
      add(LoadUsers());
    });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final users = await userRepository.getUsers();
    if (users is DataFailed) {
      emit(UserFailed(users.error!));
    }
    emit(UserLoaded(users.data!));
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    final newUser = UserEntity(
      id: const Uuid().v4(),
      name: event.name,
      lastActive: DateTime.now().toString(),
    );
    await userRepository.addUser(newUser.name, newUser.id, newUser.lastActive);
    final users = await userRepository.getUsers();
    emit(UserLoaded(users.data!));
  }
}
