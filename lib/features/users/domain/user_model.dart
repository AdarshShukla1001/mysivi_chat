import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String name;
  final Color color;

  const UserModel({required this.id, required this.name, required this.color});

  // Helper to get initials
  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
