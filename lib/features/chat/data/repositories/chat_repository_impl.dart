import '../../../../core/resources/data_state.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/local_message_data_source.dart';
import '../datasources/remote/receiver_message_remote_data_source.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ReceiverMessageRemoteDataSource remoteDataSource;
  final LocalMessageDataSource localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<DataState<MessageEntity>> fetchRandomReceiverMessage() async {
    try {
      final messageModel = await remoteDataSource.fetchRandomMessage();
      // Save received message to local storage
      await localDataSource.saveMessage(messageModel);
      return DataSuccess(messageModel);
    } on Exception catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<MessageEntity>> getHistory() async {
    return await localDataSource.getMessages();
  }

  @override
  Future<void> saveMessage(MessageEntity message) async {
    final model = MessageModel(
      id: message.id,
      body: message.body,
      likes: message.likes,
      isMe: message.isMe,
      postId: message.postId,
    );
    await localDataSource.saveMessage(model);
  }
}
