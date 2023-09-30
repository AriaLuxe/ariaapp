part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, error, success }

class ChatState extends Equatable {
  final List<Message> messages;
  final ChatStatus chatStatus;
  const ChatState({
    this.messages = const <Message>[],
    this.chatStatus = ChatStatus.initial,
  });

  ChatState copyWith({
    List<Message>? messages,
    ChatStatus? chatStatus,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      chatStatus: chatStatus ?? this.chatStatus,
    );
  }

  @override
  List<Object> get props => [messages, chatStatus];
}
