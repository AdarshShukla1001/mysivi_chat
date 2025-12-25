import 'package:equatable/equatable.dart';
import '../../domain/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;

  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}
