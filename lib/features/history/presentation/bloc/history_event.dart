import 'package:equatable/equatable.dart';
import '../../../chat/domain/chat_model.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {}

class UpdateHistory extends HistoryEvent {
  final ChatModel chat;

  const UpdateHistory(this.chat);

  @override
  List<Object?> get props => [chat];
}
