import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_model.dart';
import '../../domain/message_model.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final HistoryBloc historyBloc;

  ChatBloc({required this.chatRepository, required this.historyBloc})
    : super(ChatInitial()) {
    on<LoadChat>(_onLoadChat);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onLoadChat(LoadChat event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    // In-memory chat initialization
    final chat = ChatModel(
      chatId: event.user.id,
      user: event.user,
      messages: [],
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

      final updatedChat = currentState.chat.copyWith(
        messages: [...currentState.chat.messages, newMessage],
      );

      emit(ChatLoaded(updatedChat));
      historyBloc.add(UpdateHistory(updatedChat));

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

        final updatedChat = currentState.chat.copyWith(
          messages: [...currentState.chat.messages, receiverMessage],
        );

        emit(ChatLoaded(updatedChat));
        historyBloc.add(UpdateHistory(updatedChat));
      } catch (e) {
        // Log or handle error but keep chat fluid if possible
      }
    }
  }
}
