import 'package:flutter/material.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, dynamic>> _mockHistory = List.generate(
    20,
    (index) => {
      'name': 'User ${index + 1}',
      'lastMessage': 'This is the last message from User ${index + 1}',
      'time': '${index + 1}m ago',
      'color': Colors.primaries[index % Colors.primaries.length],
    },
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: _mockHistory.length,
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemBuilder: (context, index) {
        final item = _mockHistory[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: item['color'],
            child: Text(
              (item['name'] as String).substring(0, 1),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            item['lastMessage'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            item['time'],
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        );
      },
    );
  }
}
