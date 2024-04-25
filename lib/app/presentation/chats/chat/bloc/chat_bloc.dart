import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/validator/text_message_input_validator.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/chat_message_widget.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
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
        super(const ChatState()) {
    on<ChatEvent>((event, emit) {});
    on<MessageFetched>(_onMessageFetched);
    on<MessageSent>(_onMessageSent);
    on<ShowPlayer>(_onShowPlayer);
    on<AudioPathToSent>(_onAudioPath);
    on<DataChatFetched>(_onDataChatFetched);
    on<ClearMessages>(_onClearMessage);
    on<LoadMoreMessages>(_onLoadMoreMessages);
    on<SelectedMessage>(_onSelectedMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<CheckBlock>(_onCheckBlock);
    on<CheckIsCreator>(_onCheckIsCreator);
    on<CheckBlockMeYou>(_onCheckBlockMeYou);
    on<ToggleBlockMe>(_onToggleBlockMe);
    on<TextMessage>(_onTextMessageChanged);
    on<IsReadyTraining>(_isReadyToTraining);
  }

  void _onTextMessageChanged(
    TextMessage event,
    Emitter<ChatState> emit,
  ) {
    final textMessage = TextMessageInputValidator.dirty(event.textMessage);
    emit(
      state.copyWith(
        textMessageInputValidator: textMessage,
        isValid: Formz.validate(
          [textMessage],
        ),
      ),
    );
  }

  Future<void> _onMessageFetched(
    MessageFetched event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));
    try {
      int? userId = await SharedPreferencesManager.getUserId();

      final List<Message> messages =
          await messageRepository.getMessagesByChatId(
              event.chatId, userId!, event.page, event.pageSize);

      final chatMessage = _processMessages(messages, userId);

      emit(state.copyWith(
        messages: chatMessage,
        chatStatus: ChatStatus.success,
        isFirstMessage: chatMessage.isEmpty ? true : false,
        currentPage: 0,
        messagesData: messages,
      ));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void messageFetched(int id, int page, int pageSize) {
    add(MessageFetched(id, page, pageSize));
  }

  Future<void> _onDataChatFetched(
    DataChatFetched event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));

    try {
      final UserAria user = await userAriaRepository.getUserById(event.userId);
      emit(state.copyWith(
        name: "${user.nameUser} ${user.lastName}",
        urlPhoto: user.imgProfile,
        userId: user.id,
        chatStatus: ChatStatus.success,
      ));
    } catch (e) {
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
        messagesData: [],
        hasMoreMessages: true,
      ));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void clearMessages() {
    add(const ClearMessages());
  }

  void _clearAudioPlayer(List<AudioPlayer> audioPlayers) {
    audioPlayers.map((a) => a.dispose());
  }

  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      int? userId = await SharedPreferencesManager.getUserId();
      List<ChatMessageWidget> updatedMessage = List.from(state.messages);
      List<Message> updatedMessageData = List.from(state.messagesData);

      // 1. Agregar mensaje del usuario actual
      final userMessage = _createUserMessage(
        event.audioPath,
        event.text,
        event.typeMsg,
      );
      print(userMessage.text);
      updatedMessage.insert(0, userMessage);
      emit(state.copyWith(messages: updatedMessage, recordingResponse: true));
      // 2. Enviar mensaje a la api
      final messageCreated = await messageRepository.createMessage(
        event.chatId,
        userId!,
        event.audioPath,
        event.text,
      );
      updatedMessageData.insert(0, messageCreated);
      emit(state.copyWith(messagesData: updatedMessageData));

      final messageResponse = await messageRepository.responseMessage(
          event.chatId, event.userReceivedId, event.audioPath, event.text);
      // 3. Agregar mensaje de respuesta
      updatedMessageData.insert(0, messageResponse);

      final responseMessage =
          _createResponseMessage(messageResponse, messageResponse.msgText);
      List<ChatMessageWidget> finalMessages = List.from(state.messages);

      finalMessages.insert(0, responseMessage);
      final AudioPlayer audioPlayerNotify = AudioPlayer();
      audioPlayerNotify.setAsset('assets/audio/Eureka.mp3');
      audioPlayerNotify.play();
      emit(state.copyWith(
        chatStatus: ChatStatus.success,
        messages: finalMessages,
        messagesData: updatedMessageData,
        recordingResponse: false,
      ));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

// Función para crear el mensaje del usuario actual
  ChatMessageWidget _createUserMessage(
      String audioPath, String text, TypeMsg typeMsg) {
    final audioPlayer = AudioPlayer();

    if (audioPath == '') {
      return ChatMessageWidget(
        color: const Color(0xFF354271),
        dateTime: DateTime.now(),
        read: false,
        isMe: true,
        audioPlayer: audioPlayer,
        audioUrl: audioPath,
        typeMsg: TypeMsg.text,
        text: text,
      );
    } else {
      if (audioPath.isNotEmpty) {
        audioPlayer.setFilePath(audioPath);
      }
      return ChatMessageWidget(
        color: const Color(0xFF354271),
        dateTime: DateTime.now(),
        read: false,
        isMe: true,
        audioPlayer: audioPlayer,
        audioUrl: audioPath,
        typeMsg: TypeMsg.audio,
        text: text,
      );
    }
  }

// Función para crear el mensaje de respuesta
  ChatMessageWidget _createResponseMessage(
      Message messageResponse, String text) {
    final audioPlayerResponse = AudioPlayer();

    if (messageResponse.content == '') {
      return ChatMessageWidget(
        color: const Color(0xFF354271),
        dateTime: DateTime.now(),
        read: false,
        isMe: false,
        audioPlayer: audioPlayerResponse,
        audioUrl: '',
        typeMsg: TypeMsg.text,
        text: text,
      );
    } else {
      audioPlayerResponse
          .setUrl('${BaseUrlConfig.baseUrlImage}${messageResponse.content}');

      return ChatMessageWidget(
        color: const Color(0xFF354271),
        dateTime: DateTime.now(),
        read: messageResponse.read,
        isMe: false,
        audioPlayer: audioPlayerResponse,
        audioUrl: messageResponse.content,
        typeMsg: TypeMsg.audio,
        text: '',
      );
    }
  }

  void messageSent(int chatId, int userReceivedId, String audioPath,
      String text, TypeMsg typeMsg) {
    add(MessageSent(chatId, audioPath, userReceivedId, text, typeMsg));
  }

  // Función para procesar los mensajes
  List<ChatMessageWidget> _processMessages(List<Message> messages, int userId) {
    final List<AudioPlayer> audioControllers = [];
    final List<ChatMessageWidget> chatMessages = [];

    for (final message in messages) {
      String? audioUrl;
      AudioPlayer? audioPlayer;
      String? text;
      audioPlayer = AudioPlayer();
      if (message.msgText.isEmpty) {
        audioUrl = message.content;
        if (audioUrl != null) {
          audioPlayer.setUrl('${BaseUrlConfig.baseUrlImage}$audioUrl');
          audioControllers.add(audioPlayer);
        }

        chatMessages.add(
            //  0,
            ChatMessageWidget(
          color: const Color(0xFF354271),
          audioPlayer: audioPlayer!,
          audioUrl: audioUrl,
          dateTime: message.date,
          read: message.read,
          isMe: message.sender == userId,
          typeMsg: TypeMsg.audio,
          text: '',
        ));
      } else {
        text = message.msgText;
        chatMessages.add(ChatMessageWidget(
          color: const Color(0xFF354271),
          audioPlayer: audioPlayer,
          audioUrl: '',
          dateTime: message.date,
          read: message.read,
          isMe: message.sender == userId,
          typeMsg: TypeMsg.text,
          text: text,
        ));
      }
    }
    return chatMessages;
  }

  Future<void> _onSelectedMessage(
    SelectedMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final List<ChatMessageWidget> updatedMessages = List.from(state.messages);

      if (event.index < updatedMessages.length) {
        final ChatMessageWidget processedMessage = _processMessageSelected(
            state.messagesData[event.index],
            event.userId,
            state.messages[event.index].text.isEmpty
                ? TypeMsg.audio
                : TypeMsg.text);

        state.messages[event.index] = processedMessage;
      }

      emit(state.copyWith(
        messages: updatedMessages,
      ));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void selectedMessage(int id, int userId) {
    add(SelectedMessage(id, userId));
  }

  ChatMessageWidget _processMessageSelected(
      Message message, int userId, TypeMsg typeMsg) {
    final List<AudioPlayer> audioControllers = [];

    String? audioUrl;
    AudioPlayer? audioPlayer;
    String? text;
    if (typeMsg == TypeMsg.audio) {
      audioUrl = message.content;
      if (audioUrl != null) {
        audioPlayer = AudioPlayer();
        audioPlayer.setUrl(
            'https://uploadsaria.blob.core.windows.net/files/$audioUrl');
        audioControllers.add(audioPlayer);
      }

      return ChatMessageWidget(
        color: const Color(0xFF5368d6),
        audioPlayer: audioPlayer!,
        audioUrl: audioUrl,
        dateTime: message.date,
        read: message.read,
        isMe: message.sender == userId,
        typeMsg: typeMsg,
        text: '',
      );
    } else {
      text = message.msgText;

      return ChatMessageWidget(
        color: const Color(0xFF5368d6),
        audioPlayer: audioPlayer!,
        audioUrl: '',
        dateTime: message.date,
        read: message.read,
        isMe: message.sender == userId,
        typeMsg: typeMsg,
        text: text,
      );
    }
  }

  Future<void> _onShowPlayer(ShowPlayer event, Emitter<ChatState> emit) async {
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
      AudioPathToSent event, Emitter<ChatState> emit) async {
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

      final List<Message> moreMessages =
          await messageRepository.getMessagesByChatId(
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
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void loadMoreMessages(int id, int page, int pageSize) {
    add(LoadMoreMessages(id, page, pageSize));
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final List<ChatMessageWidget> updatedMessages = List.from(state.messages);
      final List<Message> updatedMessagesData = List.from(state.messagesData);
      await messageRepository.deleteMessage(event.messageId);
      if (event.index < updatedMessages.length) {
        // Elimina el mensaje del estado y de la lista de datos
        updatedMessages.removeAt(event.index);
        updatedMessagesData.removeAt(event.index);
      }

      emit(state.copyWith(
        messages: updatedMessages,
        messagesData: updatedMessagesData,
      ));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void deleteMessage(int messageId, int index) {
    add(DeleteMessage(messageId, index));
  }

  void _onCheckBlock(CheckBlock event, Emitter<ChatState> emit) async {
    try {
      final currentUserId = await SharedPreferencesManager.getUserId();
      final response = await userAriaRepository.checkBlock(
          event.userLooking, currentUserId!);

      if (response == false) {
        emit(state.copyWith(isBlock: false));
      } else {
        emit(state.copyWith(isBlock: true));
      }
    } catch (e) {
      emit(state.copyWith(isBlock: false));
    }
  }

  void checkBlock(int userLooking) {
    add(CheckBlock(userLooking));
  }

  void _onCheckBlockMeYou(
      CheckBlockMeYou event, Emitter<ChatState> emit) async {
    try {
      final currentUserId = await SharedPreferencesManager.getUserId();
      final response = await userAriaRepository.checkBlock(
          currentUserId!, event.userLooking);

      if (response == false) {
        emit(state.copyWith(meBlockYou: false));
      } else {
        emit(state.copyWith(meBlockYou: true));
      }
    } catch (e) {
      emit(state.copyWith(meBlockYou: false));
    }
  }

  void checkBlockMeYou(int userLooking) {
    add(CheckBlockMeYou(userLooking));
  }

  void _onToggleBlockMe(ToggleBlockMe event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(meBlockYou: !event.block));
    } catch (e) {
      emit(state.copyWith(meBlockYou: false));
    }
  }

  void onToggleBlockMe(bool block) {
    add(ToggleBlockMe(block));
  }

  void _onCheckIsCreator(CheckIsCreator event, Emitter<ChatState> emit) async {
    try {
      final response = await userAriaRepository.checkCreator(event.userId);

      if (response == false) {
        emit(state.copyWith(isCreator: false));
      } else {
        emit(state.copyWith(isCreator: true));
      }
    } catch (e) {
      emit(state.copyWith(isCreator: false));
    }
  }

  void checkCreator(int userId) {
    add(CheckIsCreator(userId));
  }

  Future<void> _isReadyToTraining(
      IsReadyTraining event, Emitter<ChatState> emit) async {
    try {
      int? userLogged = await SharedPreferencesManager.getUserId();
      final response =
          await messageRepository.isReadyToTraining(userLogged!, event.chatId);
      emit(state.copyWith(isReadyToTraining: response));
    } catch (e) {
      throw Exception(e);
    }
  }

  void isReadyToTraining(int chatId) {
    add(IsReadyTraining(chatId));
  }
}

enum TypeMsg {
  text,
  audio,
}
