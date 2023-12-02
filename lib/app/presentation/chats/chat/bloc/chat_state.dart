part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, error, success }

class ChatState extends Equatable {
  final List<ChatMessageWidget> messages;
  final List<AudioPlayer> audioControllers;
  final ChatStatus chatStatus;
  final bool isRecording;
  final bool recordingResponse;
  final String path;
  final String name;
  final String urlPhoto;
  final bool isFirstMessage;

  final int currentPage;
  final bool hasMoreMessages;
  const ChatState({
    this.isFirstMessage = false,
    this.name = '',
    this.urlPhoto = '',
    this.messages = const <ChatMessageWidget>[],
    this.audioControllers = const [],
    this.chatStatus = ChatStatus.initial,
    this.isRecording = false,
    this.recordingResponse = false,
    this.path = '',
    this.currentPage = 0,
    this.hasMoreMessages = false,
  });

  ChatState copyWith({
    List<ChatMessageWidget>? messages,
    List<AudioPlayer>? audioControllers,
    ChatStatus? chatStatus,
    bool? isRecording,
    bool? recordingResponse,
    String? path,
    String? name,
    String? urlPhoto,
    bool? isFirstMessage,
     int? currentPage,
     bool? hasMoreMessages,
  }) {
    return ChatState(
      isFirstMessage: isFirstMessage ?? this.isFirstMessage,
      name: name ?? this.name,
      urlPhoto: urlPhoto ?? this.urlPhoto,
      messages: messages ?? this.messages,
      audioControllers: audioControllers ?? this.audioControllers,
      chatStatus: chatStatus ?? this.chatStatus,
        isRecording :isRecording ?? this.isRecording,
      recordingResponse: recordingResponse ?? this.recordingResponse,
      path: path ?? this.path,
      currentPage: currentPage ?? this.currentPage,
        hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
    );
  }

  @override
  List<Object> get props => [
    isFirstMessage,
    messages,
    audioControllers,
    chatStatus,
    isRecording,
    path,
    name,
    urlPhoto,
    recordingResponse,
    currentPage,
    hasMoreMessages
  ];
}
