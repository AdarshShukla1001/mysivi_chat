import 'package:equatable/equatable.dart';
import '../../../users/domain/user_model.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChat extends ChatEvent {
  final UserModel user;

  const LoadChat(this.user);

  @override
  List<Object?> get props => [user];
}

class SendMessage extends ChatEvent {
  final String text;

  const SendMessage(this.text);

  @override
  List<Object?> get props => [text];
}

class ReceiveMessage extends ChatEvent {}
