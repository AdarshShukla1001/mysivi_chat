import 'package:equatable/equatable.dart';
import 'package:mysivi_chat/features/users/data/models/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;

  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserFailed extends UserState {
  final Exception error;

  const UserFailed(this.error);

  @override
  List<Object?> get props => [error];
}
