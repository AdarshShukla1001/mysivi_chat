import 'package:equatable/equatable.dart';
import '../../domain/chat_history_model.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ChatHistory> historyList;

  const HistoryLoaded(this.historyList);

  @override
  List<Object?> get props => [historyList];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
