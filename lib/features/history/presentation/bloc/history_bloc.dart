import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service.dart';
import '../../data/history_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;
  final MessageDbService messageDb;
  StreamSubscription? _messageSubscription;

  HistoryBloc(this.historyRepository, this.messageDb)
    : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<UpdateHistory>(_onUpdateHistory);

    _messageSubscription = messageDb.messageStream.listen((_) {
      add(LoadHistory());
    });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  Future<void> _onUpdateHistory(
    UpdateHistory event,
    Emitter<HistoryState> emit,
  ) async {
    // Simply reload everything for now to keep it synced
    final result = await historyRepository.getHistory();
    if (result is DataSuccess) {
      emit(HistoryLoaded(result.data!));
    }
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    final result = await historyRepository.getHistory();

    if (result is DataSuccess) {
      emit(HistoryLoaded(result.data!));
    } else {
      emit(HistoryError(result.error?.toString() ?? 'Failed to load history'));
    }
  }
}
