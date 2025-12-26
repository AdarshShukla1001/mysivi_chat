class UserEntity {
  final String id;
  final String name;
  final String lastActive;

  const UserEntity({
    required this.id,
    required this.name,
    required this.lastActive,
  });

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      name: map['name'],
      lastActive: map['last_active'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'last_active': lastActive};
  }
}
