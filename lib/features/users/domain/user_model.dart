import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;

  const UserModel({required this.id, required this.name});

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  List<Object?> get props => [id, name];
}
