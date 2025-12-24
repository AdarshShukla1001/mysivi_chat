import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onLoadHistory(LoadHistory event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await chatRepository.getHistory();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      try {
        final newMessage = MessageEntity(
          id: const Uuid().v4(),
          body: event.text,
          likes: 0,
          isMe: true,
        );

        await chatRepository.saveMessage(newMessage);
        
        // Optimistically update UI
        final updatedMessages = List<MessageEntity>.from(currentState.messages)..add(newMessage);
        emit(ChatLoaded(updatedMessages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    }
  }

  Future<void> _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
       final dataState = await chatRepository.fetchRandomReceiverMessage();

       if (dataState is DataSuccess && dataState.data != null) {
          final updatedMessages = List<MessageEntity>.from(currentState.messages)..add(dataState.data!);
          emit(ChatLoaded(updatedMessages));
       } else if (dataState is DataFailed) {
         emit(ChatError(dataState.error.toString()));
       }
    }
  }
}

