import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../chat/domain/repositories/chat_repository.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final ChatRepository _chatRepository;
  StreamSubscription? _updateSubscription;

  ChatHistoryBloc({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const ChatHistoryState()) {
    on<LoadChatHistory>(_onLoadChatHistory);

    // Listen for updates from repository
    _updateSubscription = _chatRepository.onChatUpdated.listen((_) {
      add(LoadChatHistory());
    });
  }

  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatHistoryState> emit,
  ) async {
    emit(state.copyWith(status: ChatHistoryStatus.loading));
    try {
      final history = await _databaseHelper.getChatHistory();
      emit(state.copyWith(status: ChatHistoryStatus.success, history: history));
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatHistoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _updateSubscription?.cancel();
    return super.close();
  }
}
