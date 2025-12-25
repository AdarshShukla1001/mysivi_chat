part of 'chat_history_bloc.dart';

enum ChatHistoryStatus { initial, loading, success, failure }

class ChatHistoryState extends Equatable {
  final ChatHistoryStatus status;
  final List<Map<String, dynamic>> history;
  final String? errorMessage;

  const ChatHistoryState({
    this.status = ChatHistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  ChatHistoryState copyWith({
    ChatHistoryStatus? status,
    List<Map<String, dynamic>>? history,
    String? errorMessage,
  }) {
    return ChatHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, history, errorMessage];
}
