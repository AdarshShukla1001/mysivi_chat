import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysivi_chat/features/users/domain/user_model.dart';
import 'bloc/user_bloc.dart';
import 'bloc/user_event.dart';
import 'bloc/user_state.dart';
import '../../chat/presentation/chat_page.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('No users found.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 10),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final userEntity = state.users[index];
                final user = UserModel(
                  id: userEntity.id,
                  name: userEntity.name,
                  color: Colors.blue,
                );

                return FutureBuilder(
                  future: context.read<UserBloc>().messageDb.getMessages(
                    user.id,
                  ),
                  builder: (context, snapshot) {
                    DateTime? lastMessageTime;

                    if (snapshot.hasData &&
                        snapshot.data?.data != null &&
                        snapshot.data!.data!.isNotEmpty) {
                      final lastMessage = snapshot.data!.data!.last;
                      lastMessageTime = DateTime.tryParse(
                        lastMessage.timestamp,
                      );
                    }

                    final subtitleText = _getSubtitleText(lastMessageTime);
                    final isOnline = subtitleText == 'Online';

                    return ListTile(
                      leading: Stack(
                        children: [
                          _GradientAvatar(initials: user.initials),

                          // Online dot
                          if (isOnline)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(user.name),
                      subtitle: Text(
                        subtitleText,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(user: user),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('Error loading users.'));
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _showAddUserDialog(context),
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF6A5AE0), // purple
                Color(0xFF4D9DE0), // blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  static String _getSubtitleText(DateTime? lastMessageTime) {
    if (lastMessageTime == null) {
      return _randomTime();
    }

    final difference = DateTime.now().difference(lastMessageTime);

    if (difference.inMinutes <= 5) {
      return 'Online';
    }

    return _formatTime(lastMessageTime);
  }

  static String _randomTime() {
    final randomMinutes = [10, 25, 40, 90, 180];
    final random = Random();
    final time = DateTime.now().subtract(
      Duration(minutes: randomMinutes[random.nextInt(randomMinutes.length)]),
    );
    return _formatTime(time);
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _showAddUserDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add User'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<UserBloc>().add(AddUser(controller.text));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// ---------------- GRADIENT AVATAR ----------------

class _GradientAvatar extends StatelessWidget {
  final String initials;

  const _GradientAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A5AE0), // purple
            Color(0xFF4D9DE0), // blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
