import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_state.dart';
import '../../chat/presentation/chat_page.dart';
import '../../../../core/utils/time_utils.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded) {
            if (state.historyList.isEmpty) {
              return const Center(child: Text('No history found.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 80),
              itemCount: state.historyList.length,
              itemBuilder: (context, index) {
                final item = state.historyList[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(item.user.initial)),
                  title: Text(item.user.name),
                  subtitle: Text(
                    item.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    TimeUtils.formatTimestamp(item.lastMessageTime),
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(user: item.user),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
