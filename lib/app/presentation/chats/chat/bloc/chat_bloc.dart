
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/message.dart';
import '../../../../security/user_logged.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository messageRepository;

  ChatBloc()
      : messageRepository = GetIt.instance<MessageRepository>(),
        super(const ChatState()) {
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
      final userLogged = GetIt.instance<UserLogged>();

      final List<Message> messages = await messageRepository
          .getMessagesByChatId(event.chatId, userLogged.userAria.id!);
      print(messages);
      emit(state.copyWith(messages: messages, chatStatus: ChatStatus.success));
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

      )async {
    try {
      final userLogged = GetIt.instance<UserLogged>();

      final message = await messageRepository.createMessage(event.chatId, userLogged.userAria.id!, event.audioPath);
      print('bloc');
      print(message.content);
      final List<Message>updatedMessages = List.from(state.messages)..add(message);
      print('mensaje actualizado');

      emit(state.copyWith(chatStatus: ChatStatus.success, messages: updatedMessages));
    } catch (e) {
emit(state.copyWith(chatStatus: ChatStatus.error));    }
  }

  void messageSent(int chatId,  String audioPath) {
    add(MessageSent(chatId,audioPath));
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
