
import 'package:ariapp/app/domain/entities/chat.dart';
import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/chat_message_widget.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/player_message.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../domain/entities/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository messageRepository;
  final UserAriaRepository userAriaRepository;
  final ChatRepository chatRepository;



  ChatBloc()
      : messageRepository = GetIt.instance<MessageRepository>(),
        userAriaRepository = GetIt.instance<UserAriaRepository>(),
        chatRepository = GetIt.instance<ChatRepository>(),

      super( const ChatState()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<MessageFetched>(_onMessageFetched);
    on<MessageSent>(_onMessageSent);
    on<ShowPlayer>(_onShowPlayer);
    on<AudioPathToSent>(_onAudioPath);
    on<DataChatFetched>(_onDataChatFetched);
    on<ClearMessages>(_onClearMessage);
    on<LoadMoreMessages>(_onLoadMoreMessages);

  }



  Future<void> _onMessageFetched(
    MessageFetched event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));
    try {
      //final userLogged = GetIt.instance<UserLogged>();
      int? userId = await SharedPreferencesManager.getUserId();

       final List<Message> messages = await messageRepository
      .getMessagesByChatId(event.chatId, userId!,event.page, event.pageSize);


      final chatMessage = _processMessages(messages,userId);

      emit(state.copyWith(
            messages: chatMessage,
            chatStatus: ChatStatus.success,
            isFirstMessage: chatMessage.isEmpty ? true: false,
            currentPage: 0,
          )
        );

    } catch (e) {
      print(e);
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }


  void messageFetched(int id, int page, int pageSize) {
    add(MessageFetched(id,page, pageSize));
  }

  Future<void> _onDataChatFetched(
      DataChatFetched event,
      Emitter<ChatState> emit,
      ) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));

    try {

      final UserAria user = await userAriaRepository.getUserById(event.userId);
      emit(state.copyWith(
        name: user.nameUser,
        urlPhoto: user.imgProfile,
        chatStatus: ChatStatus.success,
      ));

    } catch (e) {
      print(e);
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void dataChatFetched(int id) {
    add(DataChatFetched(id));
  }
  Future<void> _onClearMessage(
      ClearMessages event,
      Emitter<ChatState> emit,
      ) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));
    try {
      _clearAudioPlayer(state.audioControllers);
      emit(state.copyWith(
        messages: [],
        ));
    } catch (e) {
      print(e);
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void clearMessages() {
    add(const ClearMessages());
  }

  void _clearAudioPlayer(List<AudioPlayer> audioPlayers){
    audioPlayers.map((a) => a.dispose());

  }
  Future<void> _onMessageSent(
      MessageSent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      int? userId = await SharedPreferencesManager.getUserId();
      List<ChatMessageWidget> updatedMessage = List.from(state.messages);
      // 1. Agregar mensaje del usuario actual
      final userMessage = _createUserMessage(event.audioPath);
      updatedMessage.insert(
          0,
          userMessage);
      emit(state.copyWith(messages: updatedMessage,recordingResponse: true));
      // 2. Enviar mensaje a la api
      await messageRepository.createMessage(
        event.chatId,
        userId!,
        event.audioPath,
      );
      final messageResponse = await messageRepository.responseMessage(
        event.chatId,
        event.userReceivedId,
        event.audioPath,
      );
      // 3. Agregar mensaje de respuesta
      final responseMessage = _createResponseMessage(messageResponse);
      List<ChatMessageWidget> finalMessages = List.from(state.messages);

      finalMessages.insert(
          0,
          responseMessage
      );
      emit(state.copyWith(
        chatStatus: ChatStatus.success,
        messages: finalMessages,
        recordingResponse: false,
      ));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

// Función para crear el mensaje del usuario actual
  ChatMessageWidget _createUserMessage(String audioPath) {
    print('audioPath');
    print(audioPath);
    final audioPlayer = AudioPlayer();
    if (audioPath != null && audioPath.isNotEmpty) {
      audioPlayer.setFilePath(audioPath);
    }
    return ChatMessageWidget(
      dateTime: DateTime.now(),
      read: false,
      isMe: true,
      audioPlayer: audioPlayer,
      audioUrl: audioPath,
    );
  }

// Función para crear el mensaje de respuesta
  ChatMessageWidget _createResponseMessage(Message messageResponse) {
    final audioPlayerResponse = AudioPlayer();
    audioPlayerResponse.setUrl('https://uploadsaria.blob.core.windows.net/files/${messageResponse.content}');

    return ChatMessageWidget(
      dateTime: DateTime.now(),
      read: messageResponse.read,
      isMe: false,
      audioPlayer: audioPlayerResponse,
      audioUrl: messageResponse.content,
    );
  }

  void messageSent(int chatId, int userReceivedId,  String audioPath) {
    add(MessageSent(chatId,audioPath,userReceivedId));
  }

  // Función para procesar los mensajes
  List<ChatMessageWidget> _processMessages(List<Message> messages, int userId) {

    final List<AudioPlayer> audioControllers = [];
    final List<ChatMessageWidget> chatMessages = [];

    for (final message in messages) {

      String? audioUrl;
      AudioPlayer? audioPlayer;

          audioUrl = message.content;
      print(message.id);
          if (audioUrl != null) {
            audioPlayer = AudioPlayer();
            audioPlayer.setUrl('https://uploadsaria.blob.core.windows.net/files/$audioUrl');
            audioControllers.add(audioPlayer);
          }

      chatMessages.add(
        //  0,
          ChatMessageWidget(
            audioPlayer: audioPlayer!,
            audioUrl: audioUrl,
            dateTime: message.date,
            read: message.read,
            isMe: message.sender ==userId,
          )
      );
    }
    return chatMessages;
  }


  Future<void> _onShowPlayer(
  ShowPlayer event,
      Emitter<ChatState> emit
      ) async
  {
    try {
      if (event.isRecording) {
        emit(state.copyWith(isRecording: true));
      } else {
        emit(state.copyWith(isRecording: false));
      }

    } catch (e) {
      emit(state.copyWith(isRecording: false));
    }
  }
  void isRecording(bool isRecording) {
    add(ShowPlayer(isRecording));
  }

  Future<void> _onAudioPath(
      AudioPathToSent event,
      Emitter<ChatState> emit
      ) async
  {
    try {
      emit(state.copyWith(path: event.path));
    } catch (e) {
      emit(state.copyWith(isRecording: false));
    }
  }
  void audioPath(String path) {
    add(AudioPathToSent(path));
  }

  Future<void> _onLoadMoreMessages(
      LoadMoreMessages event,
      Emitter<ChatState> emit,
      ) async {
    try {
      int? userId = await SharedPreferencesManager.getUserId();
      print(event.page);

      final List<Message> moreMessages = await messageRepository.getMessagesByChatId(
        event.chatId,
        userId!,
        event.page,
        event.pageSize,
      );
      final chatMessage = _processMessages(moreMessages, userId);
      emit(state.copyWith(
        messages: [...state.messages, ...chatMessage],
        currentPage: state.currentPage + 1, // Increment currentPage by 1
        hasMoreMessages: moreMessages.isNotEmpty,
      ));


    } catch (e) {
      print(e);
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }
  void loadMoreMessages(int id, int page, int pageSize) {
    add(LoadMoreMessages(id,page, pageSize));
  }

}
