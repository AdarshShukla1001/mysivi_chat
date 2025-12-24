import '../../../../core/resources/data_state.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  /// Fetches a random message from the remote API (simulating a receiver).
  Future<DataState<MessageEntity>> fetchRandomReceiverMessage();

  /// Saves a message (either sent by user or received) to local storage.
  Future<void> saveMessage(MessageEntity message);

  /// Retrieves the full chat history from local storage.
  Future<List<MessageEntity>> getHistory(); // Keeping history as List for now, or should also be DataState? 
  // User asked for API to return DataState. History is local. Let's stick to API for now as per request.
  // Actually, consistency is good. Let's just do API first as requested.
}

