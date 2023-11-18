
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/chat_message_widget.dart';
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

  ChatBloc()
      : messageRepository = GetIt.instance<MessageRepository>(),
        super( const ChatState()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<MessageFetched>(_onMessageFetched);
    on<MessageSent>(_onMessageSent);
    on<ShowPlayer>(_onShowPlayer);
    on<AudioPathToSent>(_onAudioPath);


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
      .getMessagesByChatId(event.chatId, userId!);
      print('messages');



      final chatMessage = _processMessages(messages);

      emit(state.copyWith(messages: chatMessage, chatStatus: ChatStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }


  void messageFetched(int id) {
    add(MessageFetched(id));
  }

  Future<void> _onMessageSent(
      MessageSent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      int? userId = await SharedPreferencesManager.getUserId();

      final message = await messageRepository.createMessage(
        event.chatId,
        userId!,
        event.audioPath,
      );
      String? audioUrl = message.content;
      AudioPlayer audioPlayer = AudioPlayer();

      final List<AudioPlayer> audioControllers = [];

      if (audioUrl != null && audioUrl.isNotEmpty) {
        audioPlayer = AudioPlayer();
        audioPlayer.setUrl('https://uploadsaria.blob.core.windows.net/files/$audioUrl');
        audioControllers.add(audioPlayer);
      }

      final newMessage = ChatMessageWidget(
        dateTime: DateTime.now(),
        senderId: message.sender,
        read: message.read,
        isMe: true,
        audioPlayer: audioPlayer, audioUrl: audioUrl,
      );

      List<ChatMessageWidget> updatedMessage = List.from(state.messages);
      updatedMessage.insert(0, newMessage);

      emit(state.copyWith(
        chatStatus: ChatStatus.success,
        messages: updatedMessage,
      ));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }


  void messageSent(int chatId,  String audioPath) {
    add(MessageSent(chatId,audioPath));
  }


  void _setMessages(List<ChatMessageWidget> chatMessages) {
   emit(state.copyWith(
     messages: chatMessages,
    ));
  }
  // Función para procesar los mensajes




  List<ChatMessageWidget> _processMessages(List<Message> messages) {
    final List<AudioPlayer> audioControllers = [];
    final List<ChatMessageWidget> chatMessages = [];

    for (final message in messages) {

      String? audioUrl;
      AudioPlayer? audioPlayer;


          audioUrl = message.content;

          if (audioUrl != null) {
            audioPlayer = AudioPlayer();
            audioPlayer.setUrl('https://uploadsaria.blob.core.windows.net/files/$audioUrl');
            audioControllers.add(audioPlayer);
          }


      chatMessages.insert(
          0,
          ChatMessageWidget(
            audioPlayer: audioPlayer!,
            audioUrl: audioUrl,
            senderId: message.sender,
            dateTime: message.date,
            read: message.read, isMe: true,
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
      print(event.isRecording);

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

}
