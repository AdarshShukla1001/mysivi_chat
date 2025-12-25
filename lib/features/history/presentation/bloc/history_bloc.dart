import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/history_repository.dart';
import '../../domain/chat_history_model.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc(this.historyRepository) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<UpdateHistory>(_onUpdateHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final history = await historyRepository.getHistory();
    emit(HistoryLoaded(history));
  }

  Future<void> _onUpdateHistory(
    UpdateHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final historyModel = ChatHistoryModel.fromChat(event.chat);
    await historyRepository.updateHistory(historyModel);
    final history = await historyRepository.getHistory();
    emit(HistoryLoaded(history));
  }
}
