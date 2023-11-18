part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, error, success }

class ChatState extends Equatable {
  final List<ChatMessageWidget> messages;
  final List<AudioPlayer> audioControllers;
  final ChatStatus chatStatus;
  final bool isRecording;
  final String path;
  const ChatState({
    this.messages = const <ChatMessageWidget>[],
     this.audioControllers = const [],
    this.chatStatus = ChatStatus.initial,
    this.isRecording = false,
    this.path = '',
  });

  ChatState copyWith({
    List<ChatMessageWidget>? messages,
    List<AudioPlayer>? audioControllers,

    ChatStatus? chatStatus,
    bool? isRecording,
    String? path,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      audioControllers: audioControllers ?? this.audioControllers,
      chatStatus: chatStatus ?? this.chatStatus,
        isRecording :isRecording ?? this.isRecording,
      path: path ?? this.path,
    );
  }

  @override
  List<Object> get props => [messages, audioControllers,chatStatus, isRecording,path];
}
