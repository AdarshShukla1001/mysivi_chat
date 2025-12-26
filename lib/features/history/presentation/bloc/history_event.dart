import 'package:equatable/equatable.dart';
import 'package:mysivi_chat/features/history/data/chat_history_entity.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {}

class UpdateHistory extends HistoryEvent {
  final ChatHistoryEntity chat;

  const UpdateHistory(this.chat);

  @override
  List<Object?> get props => [chat];
}
