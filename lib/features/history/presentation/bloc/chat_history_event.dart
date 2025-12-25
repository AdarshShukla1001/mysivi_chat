part of 'chat_history_bloc.dart';

abstract class ChatHistoryEvent extends Equatable {
  const ChatHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadChatHistory extends ChatHistoryEvent {}
