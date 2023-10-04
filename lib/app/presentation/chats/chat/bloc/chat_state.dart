part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, error, success }

class ChatState extends Equatable {
  final List<Message> messages;
  final ChatStatus chatStatus;
  final bool isRecording;
  final String path;
  const ChatState({
    this.messages = const <Message>[],
    this.chatStatus = ChatStatus.initial,
    this.isRecording = false,
    this.path = '',
  });

  ChatState copyWith({
    List<Message>? messages,
    ChatStatus? chatStatus,
    bool? isRecording,
    String? path,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      chatStatus: chatStatus ?? this.chatStatus,
        isRecording :isRecording ?? this.isRecording,
      path: path ?? this.path,
    );
  }

  @override
  List<Object> get props => [messages, chatStatus, isRecording,path];
}
