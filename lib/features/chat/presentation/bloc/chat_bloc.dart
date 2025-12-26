import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service.dart';
import 'package:uuid/uuid.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_model.dart';
import '../../domain/message_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final MessageDbService messageDb;
  StreamSubscription? _messageSubscription;

  ChatBloc({required this.chatRepository, required this.messageDb})
    : super(ChatInitial()) {
    on<LoadChat>(_onLoadChat);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadChat(LoadChat event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    // Listen to message stream for real-time updates
    await _messageSubscription?.cancel();
    _messageSubscription = messageDb.messageStream.listen((message) {
      final currentState = state;
      if (currentState is ChatLoaded) {
        // If it's a general refresh (null) or a message for this chat
        if (message == null || message.chatId == currentState.chat.chatId) {
          add(LoadChat(currentState.chat.user));
        }
      }
    });

    final messages = await chatRepository.getChatMessages(event.user.id);
    final chat = ChatModel(
      chatId: event.user.id,
      user: event.user,
      messages: messages,
    );

    emit(ChatLoaded(chat));
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final newMessage = MessageModel(
        id: const Uuid().v4(),
        chatId: currentState.chat.chatId,
        text: event.text,
        type: MessageType.sender,
        timestamp: DateTime.now(),
      );

      await chatRepository.saveMessage(newMessage);

      final updatedChat = currentState.chat.copyWith(
        messages: [...currentState.chat.messages, newMessage],
      );

      emit(ChatLoaded(updatedChat));

      // Trigger auto-reply
      add(ReceiveMessage());
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      try {
        final receiverMessage = await chatRepository.fetchReceiverMessage(
          currentState.chat.chatId,
        );

        await chatRepository.saveMessage(receiverMessage);

        final updatedChat = currentState.chat.copyWith(
          messages: [...currentState.chat.messages, receiverMessage],
        );

        emit(ChatLoaded(updatedChat));
      } catch (e) {
        // Log or handle error but keep chat fluid if possible
      }
    }
  }
}
