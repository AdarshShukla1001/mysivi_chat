import 'package:flutter/material.dart';
import '../../domain/message_model.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/chat_repository.dart';
import '../../domain/models/word_definition_model.dart';

// Sender (Y) → Pink → Purple
const LinearGradient senderAvatarGradient = LinearGradient(
  colors: [
    Color(0xFFFF5ACD), // pink
    Color(0xFFB833FF), // purple
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Receiver (A) → Blue → Indigo
const LinearGradient receiverAvatarGradient = LinearGradient(
  colors: [
    Color(0xFF5B86FF), // blue
    Color(0xFF6C63FF), // indigo
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  void _showDefinition(BuildContext context, String word) {
    final cleanedWord = word.replaceAll(RegExp(r'[^\w]'), '');
    if (cleanedWord.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FutureBuilder<WordDefinitionModel?>(
          future: sl<ChatRepository>().getWordDefinition(cleanedWord),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final definition = snapshot.data;
            if (definition == null) {
              return SizedBox(
                height: 150,
                child: Center(
                  child: Text('No definition found for "$cleanedWord"'),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        definition.word.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (definition.phonetic != null)
                        Text(
                          definition.phonetic!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: definition.meanings.length,
                      itemBuilder: (context, index) {
                        final meaning = definition.meanings[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meaning.partOfSpeech,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            ...meaning.definitions
                                .take(2)
                                .map(
                                  (d) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      top: 4.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('• ${d.definition}'),
                                        if (d.example != null)
                                          Text(
                                            'Example: "${d.example}"',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.type == MessageType.sender;
    final words = message.text.split(RegExp(r'(\s+)'));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _Avatar(initial: 'A', isMe: false),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMe
                          ? const Radius.circular(18)
                          : Radius.zero,
                      bottomRight: isMe
                          ? Radius.zero
                          : const Radius.circular(18),
                    ),
                  ),
                  child: Wrap(
                    children: words.map((word) {
                      if (word.trim().isEmpty) {
                        return Text(
                          '$word ',
                          style: TextStyle(
                            fontSize: 15,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () => _showDefinition(context, word),
                        onLongPress: () => _showDefinition(context, word),
                        child: Text(
                          '$word ',
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  TimeUtils.formatTimestamp(message.timestamp),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe) _Avatar(initial: 'Y', isMe: true),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initial;
  final bool isMe;

  const _Avatar({required this.initial, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isMe ? senderAvatarGradient : receiverAvatarGradient,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
