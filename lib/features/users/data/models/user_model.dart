import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String name;
  final Color color;

  UserModel({required this.id, required this.name, required this.color});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'color_value': color.value};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      color: Color(map['color_value']),
    );
  }
}
