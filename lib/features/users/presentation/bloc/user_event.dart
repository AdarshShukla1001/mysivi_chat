import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final String name;

  const AddUser(this.name);

  @override
  List<Object?> get props => [name];
}
