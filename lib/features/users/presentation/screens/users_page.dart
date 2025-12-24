import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/users_cubit.dart';
import '../../data/models/user_model.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<UsersCubit, List<UserModel>>(
      builder: (context, users) {
        if (users.isEmpty) {
          return const Center(
            child: Text('No users added yet. Tap + to add one.'),
          );
        }
        return ListView.builder(
          itemCount: users.length,
          padding: const EdgeInsets.only(bottom: 80), // Space for FAB
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: user.color,
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(user.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                );
              },
            );
          },
        );
      },
    );
  }
}
