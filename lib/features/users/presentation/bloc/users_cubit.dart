import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';

class UsersCubit extends Cubit<List<UserModel>> {
  UsersCubit() : super([]);

  void addUser(String name) {
    final randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      color: randomColor,
    );
    // Emitting a new list instance to ensure Bloc updates
    emit([...state, newUser]);
  }
}
