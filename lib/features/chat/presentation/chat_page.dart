import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../users/domain/user_model.dart';
import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';
import 'widgets/message_bubble.dart';
import '../../../../core/di/service_locator.dart';
import '../../history/presentation/bloc/history_bloc.dart';

class ChatPage extends StatelessWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatBloc(chatRepository: sl(), historyBloc: sl())
            ..add(LoadChat(user)),
      child: Scaffold(
        appBar: AppBar(title: Text(user.name)),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatLoaded) {
                      return ListView.builder(
                        itemCount: state.chat.messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(
                            message: state.chat.messages[index],
                          );
                        },
                      );
                    } else if (state is ChatError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
              _MessageInput(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();

  void _send() {
    if (_controller.text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(_controller.text));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Type a message...'),
              onSubmitted: (_) => _send(),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _send),
        ],
      ),
    );
  }
}
