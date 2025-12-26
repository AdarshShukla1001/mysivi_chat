import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../users/domain/user_model.dart';
import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';
import '../../../../core/di/injection_container.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';

class ChatPage extends StatelessWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(LoadChat(user)),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: ChatAppBar(user: user),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatLoaded) {
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      itemCount: state.chat.messages.length,
                      itemBuilder: (context, index) {
                        final message = state
                            .chat
                            .messages[state.chat.messages.length - 1 - index];
                        return MessageBubble(message: message);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            const MessageInput(),
          ],
        ),
      ),
    );
  }
}
