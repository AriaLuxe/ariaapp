part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class MessageFetched extends ChatEvent {
  final int chatId;

  const MessageFetched(this.chatId);
}
class MessageSent extends ChatEvent {
  final int chatId;
  final String audioPath;

  const MessageSent( this.chatId, this.audioPath);


}